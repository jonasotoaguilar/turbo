# 🚀 Django + Next.js Boilerplate

A modern, full-stack monorepo template designed for speed and scalability. Featuring a **Django** backend powered by `uv` and a **Next.js** frontend with `pnpm`.

---

## 🛠️ Tech Stack

### 🔹 Backend (Django)

- **Framework**: Django 5.x
- **API**: Django REST Framework + SimpleJWT
- **Package Manager**: [uv](https://github.com/astral-sh/uv)
- **Documentation**: OpenAPI (Swagger/Redoc) via `drf-spectacular`
- **Database**: PostgreSQL

### 🔹 Frontend (Next.js)

- **Framework**: Next.js 14+ (App Router)
- **Styling**: Tailwind CSS
- **Package Manager**: [pnpm](https://pnpm.io/)
- **Validation**: Zod + React Hook Form
- **Auth**: NextAuth.js

### 🔹 Infrastructure

- **Containerization**: Docker + Docker Compose
- **Linting/Formatting**: [Biome](https://biomejs.dev/)

---

## 🏁 Getting Started

### 1️⃣ Prerequisites

Make sure you have the following installed:

- [Docker & Docker Compose](https://docs.docker.com/get-docker/)
- [pnpm](https://pnpm.io/installation) (optional, for local development)
- [uv](https://github.com/astral-sh/uv) (optional, for local development)

### 2️⃣ Environment Setup

Create environment files from templates:

```bash
cp .env.backend.template .env.backend
cp .env.frontend.template .env.frontend
```

### 3️⃣ Run with Docker

Start the entire stack with a single command:

```bash
docker compose up
```

- **Frontend**: [http://localhost:3000](http://localhost:3000)
- **Backend API**: [http://localhost:8001](http://localhost:8001)
- **Admin Panel**: [http://localhost:8001/admin](http://localhost:8001/admin)

---

## 📂 Project Structure

```text
.
├── backend/            # Django project root
│   ├── api/            # Main application logic
│   ├── manage.py       # Django CLI
│   └── pyproject.toml  # Python dependencies (uv)
├── frontend/           # Next.js project root
│   ├── apps/           # Frontend applications (Next.js)
│   ├── packages/       # Shared UI components and types
│   └── package.json    # Frontend dependencies (pnpm)
└── compose.yaml        # Docker orchestration
```

---

## 💻 Development Commands

### 🐍 Backend (Django)

```bash
# Register a superuser
docker compose exec api uv run -- python manage.py createsuperuser

# Run migrations
docker compose exec api uv run -- python manage.py migrate

# Add a package
docker compose exec api uv add <package-name>
```

### ⚛️ Frontend (Next.js)

```bash
# Add a package to the web app
docker compose exec web pnpm --filter web add <package-name>

# Generate TypeScript types from API schema
docker compose exec web pnpm openapi:generate
```

---

## 🛡️ Linting & Quality

We use **Biome** for fast linting and formatting.

```bash
# Format and lint code
pnpm biome check --apply .
```

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
