---
name: css
description: >
  Provides best practices for modern CSS, focusing on native nesting, container queries,
  the :has() selector, cascade layers, and accessibility.
  Trigger: When the user asks to style a component, improve CSS architecture, or implement responsive designs.
license: Apache-2.0
metadata:
  author: jonasotoaguilar
  version: "1.0"
  scope: [root, frontend]
  auto_invoke: "Adding css support"
---

## When to Use

- Architecting CSS for modern web applications.
- Implementing responsive designs using Viewport and Container Queries.
- Leveraging modern selectors like `:has()`, `:is()`, and `:where()`.
- Optimizing CSS performance and accessibility.
- Using CSS variables (Custom Properties) for themeable systems.

## Critical Patterns

### Modern Layout & Queries

- **Container Queries**: Use `@container` to style elements based on their parent's size. Avoid relying solely on `@media` for component-level responsiveness.
- **Native Nesting**: Use native CSS nesting (e.g., `.parent { .child { ... } }`) to keep styles organized without preprocessors.
- **Logical Properties**: Prefer logical properties (e.g., `margin-inline`, `padding-block`, `inset-inline-start`) over physical ones (`margin-left`, `top`) for better RTL support.

### Advanced Selectors

- **The :has() selector**: Use as a "parent selector" or for complex relational styling (e.g., `form:has(:invalid) { ... }`).
- **Cascade Layers (@layer)**: Use `@layer` to control specificity and prevent style collisions (e.g., `@layer base, components, utilities;`).

### Design Systems & Variables

- **CSS Variables**: Use `--variable-name` for tokens. Provide fallbacks: `color: var(--primary, #000);`.
- **HWB & OKLCH**: Consider using `oklch()` for more predictable and vibrant color manipulation.

### Performance & Accessibility

- **Reduce Motion**: Always respect `prefers-reduced-motion` for animations.
- **A11y**: Ensure sufficient color contrast and use `focus-visible` for keyboard navigation.
- **Performance**: Use `content-visibility: auto` for off-screen content and avoid overusing `will-change`.

## Code Examples

### Container Queries & Native Nesting

```css
.card-container {
  container-type: inline-size;
  container-name: card;
}

.card {
  display: grid;
  gap: 1rem;
  padding: 1rem;
  background: var(--bg-surface);

  /* Native Nesting */
  & .title {
    font-size: 1.25rem;
    font-weight: bold;
  }

  /* Container Query */
  @container card (min-width: 400px) {
    grid-template-columns: 100px 1fr;
    & .title {
      font-size: 1.5rem;
    }
  }
}
```

### The :has() Selector

```css
/* Style a label if the input it follows is checked */
.field:has(input:checked) label {
  color: var(--primary);
  font-weight: bold;
}

/* Style a card if it contains an image */
.card:has(img) {
  padding: 0;
  & .content {
    padding: 1rem;
  }
}
```

### Cascade Layers

```css
@layer base, components, utilities;

@layer base {
  body {
    margin: 0;
    font-family: system-ui;
  }
}

@layer components {
  .btn {
    padding: 0.5rem 1rem;
    border-radius: 4px;
  }
}

@layer utilities {
  .m-0 {
    margin: 0 !important;
  }
}
```

## Commands

```bash
# Lint CSS for best practices (if stylelint is installed)
npx stylelint "**/*.css"

# Check browser support for features
# Use tools like lightningcss for minification and bundling
npx lightningcss --minify --bundle --targets ">= 0.25%" input.css -o output.css
```

## Resources

- **Documentation**: [MDN CSS Reference](https://developer.mozilla.org/en-US/docs/Web/CSS)
- **New Features**: [Chrome for Developers - CSS](https://developer.chrome.com/blog/css-wrapped-2023/)
- **Grid Guide**: [CSS-Tricks Complete Guide to Grid](https://css-tricks.com/snippets/css/complete-guide-grid/)
