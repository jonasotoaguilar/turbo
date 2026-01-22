# ⚛️ Frontend (Next.js 16)

Este es el frontend del proyecto, una aplicación moderna construida con **Next.js 16** y **React 19**, organizada como un monorepo usando **pnpm workspaces**.

## 🚀 Tecnologías

- **Next.js 16**: App Router y soporte para Turbopack.
- **React 19**: Las últimas capacidades de la librería.
- **Tailwind CSS 4.0**: Estilos rápidos y modernos con configuración zero-runtime.
- **pnpm**: Gestor de paquetes eficiente para monorepos.
- **Next-intl**: Soporte multilenguaje (i18n).
- **NextAuth.js**: Autenticación flexible.
- **Stack de UI Premium**:
  - **Framer Motion**: Animaciones fluidas.
  - **Sonner**: Notificaciones elegantes (Toasts).
  - **Recharts**: Visualización de datos.
  - **TanStack Table/Virtual**: Tablas y listas de alto rendimiento.
  - **React Three Fiber**: Experiencias 3D integradas.
- **Biome**: Linter y formateador ultrarápido (reemplaza ESLint/Prettier).

## 🛠️ Desarrollo Local

Asegurate de tener `pnpm` instalado.

### 1. Instalación de dependencias

Desde la raíz del monorepo (`frontend/`):

```bash
pnpm install
```

### 2. Ejecución del Servidor de Desarrollo

```bash
pnpm dev
```

Esto levantará la aplicación principal (`apps/web`) en `http://localhost:3000`.

## 📂 Estructura del Monorepo

- `apps/web`: La aplicación principal de Next.js.
- `packages/ui`: Componentes compartidos de la interfaz.
- `packages/types`: Tipos compartidos y clientes de API generados.

## 🧹 Calidad de Código (Linting)

Usamos **Biome** para mantener el código impecable:

```bash
# Check y Fix automático
pnpm biome check --write .
```

## 🐳 Docker

Para correrlo en Docker desde la raíz del proyecto:

```bash
docker compose up ui
```

Accedé a la aplicación en `http://localhost:3000`.
