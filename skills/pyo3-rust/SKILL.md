---
name: pyo3-rust
description: >
  High-performance Python optimization using Rust extensions with PyO3.
  Trigger: optimizing python performance, rust extensions, maturin, pyo3, high latency functions.
license: Apache-2.0
metadata:
  author: jonasotoaguilar
  version: "1.0"
  scope: [root, backend]
  auto_invoke: "Optimizing Python performance"
---

## When to Use

Use this skill when identifying **Optimization Candidates**:

- Function executes **>10,000 times/day**.
- Execution time directly impacts **user latency**.
- Heavy CPU-bound tasks (math, parsing, string manipulation).
- Need to escape the Python GIL for parellelism.

## Critical Patterns

### 1. Native Extension (The Standard)

Use **Maturin** to build and publish Rust-backed Python modules.

- **Why**: Drop-in replacement for slow Python functions.
- **How**: Re-write CPU-intensive logic in Rust, expose via `#[pyfunction]`.

### 2. Sidecar Service

Run a persistent Rust thread/process alongside Python to handle heavy lifting.

- **Why**: Keeps Python interpreter free; handles stateful high-performance services.
- **How**: Spawn a Rust thread that communicates via channels or shared memory (with care).

### 3. Inverted Orchestrator

Rust becomes the main entry point and embeds the Python interpreter.

- **Why**: Rust controls the application lifecycle, concurrency, and critical path; Python is used only for scripting business logic.
- **How**: Use `pyo3::prepare_freethreaded_python()` or `Python::with_gil` inside a Rust `main`.

### 4. Hybrid Task Queue

Python produces tasks, Rust consumes and processes them efficiently.

- **Why**: Decouple high-throughput ingestion (Python web server) from heavy processing (Rust worker).
- **How**: Use a shared queue (like Redis or IPC) where Python pushes and Rust pops.

## Code Examples

### 1. Native Extension (lib.rs)

```rust
use pyo3::prelude::*;

#[pyfunction]
fn sum_as_string(a: usize, b: usize) -> PyResult<String> {
    Ok((a + b).to_string())
}

#[pymodule]
fn my_extension(_py: Python, m: &PyModule) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(sum_as_string, m)?)?;
    Ok(())
}
```

**Maturin Build:**

```bash
maturin develop --release
```

### 2. Sidecar Service (Background Thread)

```rust
use std::thread;
use std::sync::mpsc;
use pyo3::prelude::*;

#[pyclass]
struct BackgroundWorker {
    tx: mpsc::Sender<String>,
}

#[pymethods]
impl BackgroundWorker {
    #[new]
    fn new() -> Self {
        let (tx, rx) = mpsc::channel();

        // Spawn detached thread that lives as long as the process
        thread::spawn(move || {
            while let Ok(msg) = rx.recv() {
                println!("Rust worker processing: {}", msg);
                // Expensive op here
            }
        });

        BackgroundWorker { tx }
    }

    fn process(&self, data: String) {
        self.tx.send(data).unwrap();
    }
}
```

### 3. Inverted Orchestrator (Rust Host)

```rust
use pyo3::prelude::*;
use pyo3::types::PyList;

fn main() -> PyResult<()> {
    // Initialize Python
    pyo3::prepare_freethreaded_python();

    Python::with_gil(|py| {
        let sys = py.import("sys")?;
        let version: String = sys.getattr("version")?.extract()?;
        println!("Python version: {}", version);

        let list = PyList::new(py, &[1, 2, 3]);
        let locals = [("my_list", list)].into_py_dict(py);

        // Run Python code from Rust
        py.run("print(f'Hello from Python! List: {my_list}')", None, Some(locals))?;
        Ok(())
    })
}
```

### 4. Hybrid Task Queue (Concept)

_Note: This usually requires an external broker or shared memory IPC, simplistic example using channels within a module not possible across process boundaries without IPC tools like shared_memory crate._

**Python (Producer via PyO3 binding):**

```python
import my_rust_queue
# Pushes to a queue managed by Rust
my_rust_queue.push_task({"id": 1, "payload": "heavy data"})
```

**Rust (Consumer implementation):**

```rust
// In lib.rs
#[pyfunction]
fn push_task(task: String) {
    // Push to global static queue or channel
    GLOBAL_QUEUE.lock().unwrap().push(task);
    // Worker runs in background thread
}
```

## Commands

```bash
# Initialize new Maturin project
maturin new my-project --binding pyo3

# Build and install in current venv
maturin develop

# Build wheel for release
maturin build --release
```
