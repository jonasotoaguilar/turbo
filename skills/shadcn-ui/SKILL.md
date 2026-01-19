---
name: shadcn-ui
description: >
  Best practices for using shadcn/ui components in React 19 projects.
  Trigger: When installing UI components, configuring shadcn/ui, or building custom design systems using basic primitives.
license: Apache-2.0
metadata:
  author: jonasotoaguilar
  version: "1.0"
  scope: [root, frontend]
  auto_invoke: "Adding shadcn-ui support"
---

## When to Use

- Building accessible and consistent UI components with Tailwind CSS and Radix UI.
- Initializing shadcn/ui in a new React 19 / Next.js project.
- Customizing component styles via `cn()` utility or CSS variables.
- Integrating complex UI patterns like Dialogs, Sheets, or Data Tables.

## Critical Patterns

### 1. Initialization & CLI (REQUIRED)

Use the CLI to initialize and add components. This ensures proper dependency management and configuration.

- **React 19 Note**: If using `npm`, you might need `--force` or `--legacy-peer-deps`. With `pnpm`, it usually works out of the box, but stay alert for peer dependency errors.

### 2. Component Organization

- Components are added to `@/components/ui` (or your configured path).
- Don't edit the base components in `ui/` unless strictly necessary for global changes.
- Compose base components into higher-level "feature" components.

### 3. Theming & Styling

- **CSS Variables**: Prefer `cssVariables: true` in `components.json` for dynamic theming (dark mode).
- **cn() Utility**: Always use the provided `cn(...inputs)` utility to group and merge Tailwind classes.
- **Base Color**: Choose a consistent base color (e.g., `zinc`, `slate`) during initialization.

### 4. Integration with RHF & Zod

- shadcn/ui provides a `Form` component that wraps **React Hook Form**. Use the `FormField` pattern for consistent labeling and error messaging.

## Code Examples

### Initialization

```bash
# Initialize shadcn/ui
pnpm dlx shadcn@latest init

# Add specific components
pnpm dlx shadcn@latest add button input card dialog
```

### Using a Component with `cn()`

```tsx
import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";

export function CustomButton({ className, ...props }) {
  return (
    <Button
      className={cn("bg-brand-500 hover:bg-brand-600", className)}
      {...props}
    />
  );
}
```

### Complex Composition (Dialog)

```tsx
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";

export function MyDialog() {
  return (
    <Dialog>
      <DialogTrigger asChild>
        <Button variant="outline">Open Modal</Button>
      </DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Are you absolutely sure?</DialogTitle>
          <DialogDescription>
            This action cannot be undone. This will permanently delete your
            account.
          </DialogDescription>
        </DialogHeader>
      </DialogContent>
    </Dialog>
  );
}
```

## Commands

```bash
# Initialize (with pnpm)
pnpm dlx shadcn@latest init

# Add components
pnpm dlx shadcn@latest add [component-name]

# Check components updates
pnpm dlx shadcn@latest diff
```

## Resources

- **Official Docs**: [shadcn/ui Documentation](https://ui.shadcn.com/)
- **Components**: [Browse Components](https://ui.shadcn.com/docs/components/accordion)
- **Theming**: [Theming Guide](https://ui.shadcn.com/docs/theming)
- **React 19**: [React 19 Compatibility](https://ui.shadcn.com/docs/react-19)
