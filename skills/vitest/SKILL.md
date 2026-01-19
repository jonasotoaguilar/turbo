---
name: vitest
description: >
  Configures and writes tests using Vitest (Unit) and Testing Library (Component).
  Trigger: asking for test setup, writing unit/component tests, checking coverage, or fixing failing tests.
license: Apache-2.0
metadata:
  author: google-deepmind
  version: "1.0"
  scope: [root, frontend]
  auto_invoke: "Adding vitest support"
---

## When to Use

- Setting up a test runner for a new project (Vite-native).
- Writing Unit Tests for logic/functions (Vitest).
- Writing Component Tests for React (Testing Library).
- configuring test coverage or CI test scripts.
- Debugging or mocking external dependencies/timers.

## Critical Patterns

### 1. Configuration (`vitest.config.ts`)

- Use `defineProject` or `mergeConfig` if extending Vite config.
- Set `environment: 'jsdom'` for React/DOM testing.
- Configure `globals: true` if you prefer Jest-like global APIs (describe, it, expect), **but ensure `types` are added to `tsconfig.json`**.
- Use `setupFiles` to initialize global mocks (e.g., `setupTests.ts` for `@testing-library/jest-dom`).

### 2. Unit Testing Strategy

- **Logic first**: Test pure functions in isolation.
- **Mocking**: Use `vi.mock()` for modules and `vi.spyOn()` for methods.
- **Timers**: Use `vi.useFakeTimers()` for stable time-dependent tests.
- **Parametrized Tests**: Use `it.each` for multiple cases.

### 3. Component Testing (React Testing Library)

- **User Events**: ALWAYs use `userEvent.setup()` and `await userEvent.click/type`.
- **Queries**: Prioritize **Accessibility** queries:
  1.  `getByRole` (best for a11y)
  2.  `getByLabelText` (forms)
  3.  `getByPlaceholderText`
  4.  `getByText` (content)
  5.  `getByTestId` (last resort)
- **Async**: Use `findByRole`/`findByText` (which await) for elements that appear asynchronously.
- **No Implementation Details**: Do not test strict structure (e.g., specific classes, DOM hierarchy) unless necessary. Test behavior and visibility.
- **Custom Render**: Create a `test-utils.tsx` to wrap components with necessary providers (Theme, QueryClient, Store).

## Code Examples

### 1. Basic Unit Test (Logic)

```typescript
// math.test.ts
import { describe, it, expect } from "vitest";
import { add } from "./math";

describe("add function", () => {
  it("adds two numbers correctly", () => {
    expect(add(2, 3)).toBe(5);
  });

  // Parametrized
  it.each([
    [1, 1, 2],
    [2, 3, 5],
    [10, -2, 8],
  ])("adds %i + %i to equal %i", (a, b, expected) => {
    expect(add(a, b)).toBe(expected);
  });
});
```

### 2. Component Test (React + User Event)

```tsx
// Counter.test.tsx
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import { Counter } from "./Counter";

describe("Counter", () => {
  it("increments count on click", async () => {
    // 1. Setup User
    const user = userEvent.setup();

    // 2. Render
    render(<Counter />);

    // 3. Verify initial state
    const button = screen.getByRole("button", { name: /count is 0/i });
    expect(button).toBeInTheDocument();

    // 4. Act (Async interaction)
    await user.click(button);

    // 5. Assert result
    // Note: Re-query if text changes or use variable if ref is stable (generic button)
    expect(
      screen.getByRole("button", { name: /count is 1/i }),
    ).toBeInTheDocument();
  });
});
```

### 3. Mocking Modules & Time

```typescript
import { vi, describe, it, expect, beforeEach, afterEach } from "vitest";
import { performAction } from "./action";

// Mock entire module
vi.mock("./api", () => ({
  fetchData: vi.fn(() => Promise.resolve({ data: "mocked" })),
}));

describe("Time and Mocking", () => {
  beforeEach(() => {
    vi.useFakeTimers();
  });

  afterEach(() => {
    vi.useRealTimers();
    vi.restoreAllMocks();
  });

  it("delays execution", () => {
    const callback = vi.fn();
    setTimeout(callback, 1000);

    vi.advanceTimersByTime(1000);
    expect(callback).toHaveBeenCalled();
  });
});
```

## Commands

```bash
# Run tests
pnpm vitest

# Run with coverage
pnpm vitest run --coverage

# Run UI mode
pnpm vitest --ui

# Watch specific file
pnpm vitest match/to/file
```

## Resources

- **Vitest Docs**: [vitest.dev](https://vitest.dev)
- **Testing Library**: [testing-library.com](https://testing-library.com)
- **Interactive UI**: `pnpm vitest --ui` for visual debugging.
