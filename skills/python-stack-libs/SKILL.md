---
name: python-stack-libs
description: >
  Best practices for the modern Python stack: Pydantic, Polars, Typer, Rich, Watchdog, Schedule, and document generation.
  Trigger: using python, pydantic, polars, typer, rich, creating clis, processing data, generating pdfs/word docs.
license: Apache-2.0
metadata:
  author: jonasotoaguilar
  version: "1.0"
  scope: [root, backend]
  auto_invoke: "Adding python support"
---

## When to Use

- **Data Validation & Settings**: Use **Pydantic V2** for reliable data parsing, validation, and managing environment variables.
- **Data Processing**: Use **Polars** instead of Pandas for high-performance, lazy-evaluated data manipulation.
- **CLI Development**: Use **Typer** combined with **Rich** for building beautiful, self-documenting command-line interfaces.
- **Background Tasks**: Use **Watchdog** for file monitoring and **Schedule** for lightweight periodic jobs.
- **Document Generation**: Use **python-docx** for Word documents and **ReportLab** for programmatic PDF generation.

## Critical Patterns

### Pydantic V2 (Validation)

- Use `model_validator(mode='after')` for cross-field validation.
- Use `field_validator` for single field validation.
- Use `pydantic-settings` for robust environment configuration.
- Prefer `Annotated` types for metadata (e.g. `Field` info).

### Polars (Data)

- Always prefer the **Lazy API** (`scan_csv`, `scan_parquet`) for optimizations.
- Use `q.collect()` specifically when you need the result.
- Avoid iterating over rows; use **Expressions** (`pl.col`, `pl.when`, etc.).
- Use `fill_null` and `drop_nulls` for explicit cleanups.

### Typer + Rich (CLI)

- Use `Annotated[Type, typer.Option(...)]` for modern argument definition.
- Use `rich.console.Console` for all output (replaces `print`).
- Use `rich.progress` for long-running operations.
- Set `rich_markup_mode="rich"` in Typer apps for formatted help text.

### Infrastructure (Watchdog & Schedule)

- Keep event handlers stateless in Watchdog.
- Run the Schedule loop in a separate thread if blocking the main thread changes.

---

## Code Examples

### 1. Pydantic V2 - Settings & Validation

```python
from typing import Annotated, Literal
from pydantic import BaseModel, Field, field_validator, model_validator
from pydantic_settings import BaseSettings

class AppSettings(BaseSettings):
    env: Literal["dev", "prod"] = "dev"
    db_url: str = Field(..., pattern=r"^postgres://")

    class Config:
        env_file = ".env"

class User(BaseModel):
    id: int
    name: str
    email: Annotated[str, Field(min_length=5)]
    age: int | None = None

    @field_validator("name")
    @classmethod
    def title_case_name(cls, v: str) -> str:
        return v.title()

    @model_validator(mode="after")
    def check_age_rule(self) -> "User":
        if self.env == "prod" and self.age is None:
             # Example conditional logic
             raise ValueError("Age required in prod")
        return self
```

### 2. Polars - Efficient Data Processing

```python
import polars as pl

def process_data(file_path: str):
    q = (
        pl.scan_csv(file_path)
        .filter(pl.col("status") == "active")
        .with_columns(
            (pl.col("price") * 1.2).alias("price_with_tax"),
            pl.col("category").str.to_uppercase()
        )
        .group_by("category")
        .agg([
            pl.col("price_with_tax").sum().alias("total_sales"),
            pl.count("id").alias("item_count")
        ])
    )
    # Execute optimized plan
    return q.collect()
```

### 3. Typer + Rich - CLI

```python
import typer
from typing import Annotated
from rich.console import Console
from rich.progress import track
import time

app = typer.Typer(rich_markup_mode="rich")
console = Console()

@app.command()
def sync(
    force: Annotated[bool, typer.Option("--force", "-f", help="Force [red]sync[/]")] = False
):
    """
    Synchronize data with the [bold blue]cloud[/].
    """
    if force:
        console.print("[yellow]Force mode enabled![/]")

    cities = ["New York", "London", "Tokyo"]
    for city in track(cities, description="Syncing..."):
        time.sleep(1)
        console.print(f"Synced {city}")

if __name__ == "__main__":
    app()
```

### 4. Watchdog & Schedule - Services

```python
import schedule
import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

class FileHandler(FileSystemEventHandler):
    def on_modified(self, event):
        if not event.is_directory:
            print(f"File {event.src_path} modified")

def job():
    print("Running scheduled task...")

# Scheduling
schedule.every(10).minutes.do(job)

# Watchdog
observer = Observer()
observer.schedule(FileHandler(), path=".", recursive=False)
observer.start()

# Main loop
try:
    while True:
        schedule.run_pending()
        time.sleep(1)
except KeyboardInterrupt:
    observer.stop()
observer.join()
```

### 5. Document Generation (Docx & ReportLab)

```python
from docx import Document
from reportlab.pdfgen import canvas

def create_report(filename: str):
    # Word
    doc = Document()
    doc.add_heading('Monthly Report', 0)
    doc.add_paragraph('This is an automated report.')
    doc.save(f"{filename}.docx")

    # PDF
    c = canvas.Canvas(f"{filename}.pdf")
    c.drawString(100, 750, "Monthly Report PDF")
    c.save()
```

---

## Commands

```bash
# Install the modern stack (using pnpm/uv is recommended, here using pip for generic compat)
pip install pydantic pydantic-settings polars typer rich watchdog schedule python-docx reportlab

# Run a typer app
python main.py --help
```
