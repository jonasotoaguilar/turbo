---
name: html-5
description: >
  Provides best practices for modern HTML5, emphasizing semantic structure,
  web components, performance optimizations (lazy loading, fetch priority), accessibility,
  and LLM visibility (AI-friendly markup).
  Trigger: When the user asks to create or structure a web page, implement UI components, or optimize site performance, SEO, and AI readability.
license: Apache-2.0
metadata:
  author: jonasotoaguilar
  version: "1.0"
  scope: [root, frontend]
  auto_invoke: "Adding html-5 support"
---

## When to Use

- Structuring web pages using semantic HTML5 elements.
- Implementing accessible UI patterns (ARIA, roles).
- Optimizing resource loading (Images, Scripts).
- Creating reusable UI components with Web Components.
- Enhancing SEO and LLM Visibility with proper meta tags and Microdata/JSON-LD.
- Optimizing content structure for AI extraction (GEO - Generative Engine Optimization).
- Accessibility is not optional: Semantic HTML, ARIA roles where applicable, and managed focus.

## Critical Patterns

### Semantic HTML

- **Meaningful Tags**: Use `<main>`, `<header>`, `<footer>`, `<nav>`, `<aside>`, and `<article>` instead of generic `<div>` blocks.
- **Sectioning**: Use `<section>` for thematic groupings and `<article>` for independent, distributable content.
- **Figures**: Wrap images and diagrams in `<figure>` with a `<figcaption>`.

### Modern Attributes & APIs

- **Native Lazy Loading**: Add `loading="lazy"` to `<img>` and `<iframe>` to defer loading off-screen content.
- **Fetch Priority**: Use `fetchpriority="high"` for critical resources (e.g., LCP image) or `"low"` for non-essential ones.
- **Popover API**: Use the `popover` attribute for tooltips, menus, and notifications without complex JS.
- **Dialog**: Use the native `<dialog>` element for modals, leveraging `.showModal()` for proper focus management and accessibility.

### Web Components

- **Templates & Slots**: Use `<template>` to define reusable markup and `<slot>` to project content into Shadow DOM.

### Accessibility (A11y)

- **First-Rule of ARIA**: If a native HTML element exists (e.g., `<button>`, `<nav>`), use it instead of ARIA roles.
- **Interactivity**: Ensure all interactive elements have labels (`aria-label` or `<label>`) and are keyboard-reachable.
- **Image Alts**: Always provide descriptive `alt` text or `alt=""` for decorative images.

### SEO & Performance

- **Meta Tags**: Include `<title>`, `<meta name="description">`, and Open Graph tags for social sharing.
- **Viewport**: Always include `<meta name="viewport" content="width=device-width, initial-scale=1.0">`.
- **Preload/Prefetch**: use `<link rel="preload">` for critical assets.

### LLM Visibility (Machine Readability)

- **Conversational Structure**: Use clear headers (`<h1>`, `<h2>`) in question format to match conversational search patterns.
- **Summary First**: Provide a direct answer or summary at the beginning of sections (AI models love summaries).
- **Structured Data (JSON-LD)**: ALWAYS include JSON-LD schemas (`application/ld+json`) to provide explicit context to LLMs.
- **Microdata**: Use `itemscope`, `itemtype`, and `itemprop` to define semantic meaning within the HTML.
- **Objective Content**: Prioritize data-backed, objective content. LLMs prefer extraction-friendly formats (tables, lists).
- **External Validation**: Ensure metadata includes links to external sources or expert citations.

## Code Examples

### Semantic Layout with Modern Features

```html
<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Modern HTML5 Showcase</title>
    <meta
      name="description"
      content="A demonstration of modern HTML5 best practices."
    />
    <!-- Preload Largest Contentful Paint image -->
    <link rel="preload" href="hero.webp" as="image" fetchpriority="high" />
  </head>
  <body>
    <header>
      <nav>
        <ul>
          <li><a href="#main">Inicio</a></li>
        </ul>
      </nav>
    </header>

    <main id="main">
      <article>
        <h1>Bienvenidos al Futuro del Web</h1>
        <p>Contenido principal con semántica clara.</p>

        <figure>
          <img
            src="content.jpg"
            alt="Descripción de la imagen"
            loading="lazy"
          />
          <figcaption>Imagen con carga diferida nativa.</figcaption>
        </figure>

        <!-- Popover API example -->
        <button popovertarget="info-menu">Ver Info</button>
        <div id="info-menu" popover>
          <p>Este es un popover nativo sin JavaScript!</p>
        </div>
      </article>

      <!-- Dialog / Modal example -->
      <dialog id="fav-dialog">
        <form method="dialog">
          <p>¿Te gusta HTML5?</p>
          <button value="yes">Sí</button>
          <button value="no">No</button>
        </form>
      </dialog>
      <button onclick="document.getElementById('fav-dialog').showModal()">
        Abrir Modal
      </button>
    </main>

    <footer>
      <p>&copy; 2024 Modern Web Architect</p>
    </footer>
  </body>
</html>
```

### LLM-Friendly HTML with JSON-LD

```html
<article itemscope itemtype="https://schema.org/TechArticle">
  <!-- Structured data for LLMs -->
  <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "TechArticle",
      "headline": "¿Cómo optimizar HTML para LLMs?",
      "description": "Guía práctica sobre maximizar la visibilidad en modelos de IA.",
      "author": {
        "@type": "Person",
        "name": "Senior Architect"
      }
    }
  </script>

  <!-- Conversational header -->
  <header>
    <h1 itemprop="headline">¿Cómo lograr que la IA encuentre mi contenido?</h1>
    <p class="summary" itemprop="abstract">
      <strong>Resumen:</strong> La optimización para LLMs (GEO) requiere
      estructura semántica, datos estructurados (JSON-LD) y respuestas directas
      a preguntas contextuales.
    </p>
  </header>

  <section>
    <h2>1. Estructura para extracción</h2>
    <p>Los modelos no leen, extraen. Usá tablas y listas:</p>
    <table role="table">
      <thead>
        <tr>
          <th>Táctica</th>
          <th>Impacto en IA</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>JSON-LD</td>
          <td>Contexto explícito de máquina</td>
        </tr>
        <tr>
          <td>Heading-Questions</td>
          <td>Match con intención de búsqueda</td>
        </tr>
      </tbody>
    </table>
  </section>
</article>
```

## Commands

```bash
# Validate HTML for accessibility and standards (if html-validate is installed)
npx html-validate **/*.html

# Run a local dev server to preview changes
npx serve .
```

## Resources

- **Documentation**: [MDN HTML Reference](https://developer.mozilla.org/en-US/docs/Web/HTML)
- **A11y Patterns**: [W3C WAI-ARIA Authoring Practices](https://www.w3.org/WAI/ARIA/apg/)
- **Popover API**: [Chrome for Developers - Popover API](https://developer.chrome.com/blog/introducing-popover-api/)
- **Web Components**: [WebComponents.org](https://www.webcomponents.org/)
