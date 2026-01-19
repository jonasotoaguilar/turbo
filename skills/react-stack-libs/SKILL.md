---
name: react-stack-libs
description: >
  Best practices for React Hook Form, TanStack Table, TanStack Virtual, Framer Motion, React Three Fiber, Recharts, and date-fns.
  Trigger: When implementing forms, data tables, animations, 3D rendering, charts, or date handling in React applications.
license: Apache-2.0
metadata:
  author: jonasotoaguilar
  version: "1.0"
  scope: [root, frontend]
  auto_invoke: "Adding react support"
---

# React Stack Libraries Standards

This skill defines the authoritative best practices for key libraries in our React stack.

## 1. Forms: React Hook Form

**Why:** Performance (no re-renders), ease of use, and great ecosystem.

**Installation:**

```bash
pnpm add react-hook-form @hookform/resolvers zod
```

**Best Practices:**

1.  **Schema First:** Always define validation logic with Zod schema.
2.  **Uncontrolled:** Leverage uncontrolled inputs (`register`) for performance. Avoid `Controller` unless using 3rd party UI components (e.g., Select, DatePicker).
3.  **Typed:** Use `useForm<Type>` or let Zod infer types.

**Standard Pattern:**

```tsx
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";

const schema = z.object({
  email: z.string().email(),
  role: z.enum(["admin", "user"]),
});

type FormValues = z.infer<typeof schema>;

export function UserForm() {
  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: { role: "user" }, // Important for uncontrolled inputs
  });

  const onSubmit = (data: FormValues) => console.log(data);

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register("email")} />
      {errors.email && <span>{errors.email.message}</span>}
      <button type="submit">Save</button>
    </form>
  );
}
```

---

## 2. Data Tables: TanStack Table (React Table v8)

**Why:** Headless, type-safe, highly customizable.

**Installation:**

```bash
pnpm add @tanstack/react-table
```

**Best Practices:**

1.  **Headless:** You build the UI (`<table>`, `<div>`). The library manages state.
2.  **Memoization:** `columns` and `data` MUST be memoized (`useMemo`) or stable references.
3.  **Helper:** Use `createColumnHelper` for type safety when defining columns.

**Standard Pattern:**

```tsx
import {
  useReactTable,
  getCoreRowModel,
  flexRender,
  createColumnHelper,
} from "@tanstack/react-table";

const columnHelper = createColumnHelper<User>();

const columns = [
  columnHelper.accessor("name", { header: "Name" }),
  columnHelper.accessor("email", { header: "Email" }),
];

const table = useReactTable({
  data,
  columns,
  getCoreRowModel: getCoreRowModel(),
});

// Render loop:
// table.getHeaderGroups()...
// table.getRowModel().rows...
```

---

## 3. Animation: Framer Motion

**Why:** Declarative, powerful layout animations, gestures.

**Installation:**

```bash
pnpm add framer-motion
```

**Best Practices:**

1.  **Lazy Motion:** For bundle size optimization, use `LazyMotion` if animations are heavy.
2.  **Variants:** Use `variants` object for complex parent-child orchestrations.
3.  **AnimatePresence:** Wrap components in `<AnimatePresence>` for exit animations.

**Standard Pattern:**

```tsx
import { motion, AnimatePresence } from "framer-motion";

const variants = {
  hidden: { opacity: 0, y: 10 },
  visible: { opacity: 1, y: 0 },
};

<AnimatePresence>
  {isVisible && (
    <motion.div
      initial="hidden"
      animate="visible"
      exit="hidden"
      variants={variants}
    >
      Content
    </motion.div>
  )}
</AnimatePresence>;
```

---

## 4. 3D: React Three Fiber (R3F)

**Why:** Declarative Three.js in React.

**Installation:**

```bash
pnpm add three @types/three @react-three/fiber @react-three/drei
```

**Best Practices:**

1.  **Drei:** Always use `@react-three/drei` helpers (OrbitControls, Environment, Text) to save time.
2.  **Canvas:** One `<Canvas>` per scene. It's heavy.
3.  **Hooks:** Use `useFrame` for loop logic (rotation, animation) instead of React state to avoid re-renders.

**Standard Pattern:**

```tsx
import { Canvas, useFrame } from "@react-three/fiber";
import { OrbitControls, Box } from "@react-three/drei";
import { useRef } from "react";

function RotatingBox() {
  const meshRef = useRef(null);
  useFrame((state, delta) => (meshRef.current.rotation.x += delta));

  return (
    <Box ref={meshRef}>
      <meshStandardMaterial color="orange" />
    </Box>
  );
}

// Check R3F docs for Canvas wrapping
```

---

## 5. Charts: Recharts

**Why:** Composable, reliable SVG-based charts.

**Installation:**

```bash
pnpm add recharts
```

**Best Practices:**

1.  **Responsive:** Always wrap in `<ResponsiveContainer>` (usually `width="100%"` and fixed `height`).
2.  **Keys:** Ensure data has unique keys if doing animations.
3.  **Customization:** Use custom components for `Tooltip` content if default is ugly.

**Standard Pattern:**

```tsx
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  Tooltip,
  ResponsiveContainer,
} from "recharts";

<ResponsiveContainer width="100%" height={300}>
  <LineChart data={data}>
    <XAxis dataKey="name" />
    <YAxis />
    <Tooltip />
    <Line type="monotone" dataKey="value" stroke="#8884d8" />
  </LineChart>
</ResponsiveContainer>;
```

---

## 6. Dates: date-fns

**Why:** Modular, immutable, lightweight (tree-shakeable), functional.

**Installation:**

```bash
pnpm add date-fns
```

**Best Practices:**

1.  **Importing:** Import specific functions to keep bundles small (e.g., `import { format } from 'date-fns'`).
2.  **Locales:** Be mindful of locales (`date-fns/locale`). Pass them to functions if needed.
3.  **Timezones:** Use `date-fns-tz` if handling complex timezone conversions.

**Standard Pattern:**

```tsx
import { format, formatDistanceToNow, addDays } from "date-fns";
import { es } from "date-fns/locale";

const date = new Date();
const formatted = format(date, "d 'de' MMMM", { locale: es }); // "18 de enero"
const relative = formatDistanceToNow(date, { addSuffix: true, locale: es });
```

---

## 7. Virtualization: TanStack Virtual

**Why:** Rendering large lists/grids without performance hits.

**Installation:**

```bash
pnpm add @tanstack/react-virtual
```

**Best Practices:**

1.  **Hierarchy:** Parent (fixed height, overflow auto) -> Inner (relative, total size) -> Items (absolute, transform).
2.  **Dynamic:** Use `measureElement` ref for dynamic heights.
3.  **Keys:** Use `virtualItem.key` not just index.

**Standard Pattern:**

```tsx
import { useVirtualizer } from "@tanstack/react-virtual";
import { useRef } from "react";

function VirtualList({ items }) {
  const parentRef = useRef(null);

  const rowVirtualizer = useVirtualizer({
    count: items.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => 45,
  });

  return (
    <div ref={parentRef} style={{ height: "400px", overflow: "auto" }}>
      <div
        style={{
          height: `${rowVirtualizer.getTotalSize()}px`,
          position: "relative",
        }}
      >
        {rowVirtualizer.getVirtualItems().map((virtualRow) => (
          <div
            key={virtualRow.key}
            ref={rowVirtualizer.measureElement}
            data-index={virtualRow.index}
            style={{
              position: "absolute",
              top: 0,
              left: 0,
              width: "100%",
              transform: `translateY(${virtualRow.start}px)`,
            }}
          >
            {items[virtualRow.index]}
          </div>
        ))}
      </div>
    </div>
  );
}
```
