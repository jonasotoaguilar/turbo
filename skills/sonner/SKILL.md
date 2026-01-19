---
name: sonner
description: >
  Best practices for notifications and feedback with Sonner in React 19.
  Trigger: When implementing toasts, notifications, or user feedback mechanisms using the Sonner library.
license: Apache-2.0
metadata:
  author: jonasotoaguilar
  version: "1.0"
  scope: [root, frontend]
  auto_invoke: "Adding sonner support"
---

## When to Use

- Displaying non-blocking notifications (success, error, info, warning).
- Providing feedback for asynchronous processes (promises).
- Implementing rich, customizable toast messages with action buttons.
- Standardizing the notification system in a React 19 / Next.js project.

## Critical Patterns

### 1. Global Toaster Setup (REQUIRED)

The `<Toaster />` component MUST be rendered at the root of your application (usually in `layout.tsx` or `App.tsx`) to ensure it's available globally and doesn't get unmounted.

### 2. Handling Async Actions (Promises)

Use `toast.promise` to handle loading, success, and error states of a promise in a single call. This is much better than manual state management for notifications.

### 3. Positioning and Rich Colors

- **Position**: Configure the `position` prop on `<Toaster />` (default is `bottom-right`).
- **Rich Colors**: Use the `richColors` prop on `<Toaster />` to color-code different toast types (success/red, error/green, etc.).

### 4. Custom Components

Avoid over-styling base toasts. If you need a completely custom look, pass a React component to `toast()`.

## Code Examples

### Basic Setup (Next.js Layout)

```tsx
import { Toaster } from "sonner";

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>
        {children}
        <Toaster richColors closeButton position="top-right" />
      </body>
    </html>
  );
}
```

### Triggering Toasts

```tsx
import { toast } from "sonner";

// Basic
toast("Item deleted");

// Specific types (with richColors)
toast.success("Profile updated");
toast.error("Failed to save changes");
toast.warning("Storage is almost full");
toast.info("New update available");
```

### Managing Promises (Action Example)

```tsx
async function saveData() {
  const promise = fetch("/api/save", { method: "POST" });

  toast.promise(promise, {
    loading: "Saving your changes...",
    success: (data) => `Saved successfully!`,
    error: "Could not save. Please try again.",
  });
}
```

### Toast with Action Button

```tsx
toast("Event created", {
  description: "Sunday, December 03, 2023 at 9:00 AM",
  action: {
    label: "Undo",
    onClick: () => console.log("Undo"),
  },
});
```

## Commands

```bash
# Install Sonner
pnpm add sonner
```

## Resources

- **Official Docs**: [Sonner Documentation](https://sonner.emilkowal.ski/)
- **Shadcn Integration**: [Shadcn Sonner](https://ui.shadcn.com/docs/components/sonner)
