# 🐍 Backend API (Django)

Este es el backend del proyecto, construido con **Django 5.1** y gestionado con **uv**.

## 🚀 Tecnologías

- **Django 5.1**: Framework robusto y escalable.
- **uv**: Gestor de paquetes y entornos de Python extremadamente rápido.
- **Django REST Framework (DRF)**: Para la construcción de APIs.
- **SimpleJWT**: Autenticación basada en JWT.
- **drf-spectacular**: Generación automática de esquema OpenAPI 3.
- **Django Unfold**: Panel de administración moderno.
- **Pytest**: Testing unitario y de integración.
- **Ruff**: Linter y formateador de alto rendimiento.

## 🛠️ Desarrollo Local

Asegurate de tener `uv` instalado en tu sistema.

### 1. Instalación de dependencias

```bash
uv sync --python 3.13
```

### 2. Base de Datos

El backend espera una base de datos PostgreSQL. Podés usar la que levanta Docker configurando las variables en el `.env` de la raíz.

### 3. Ejecución del Servidor

```bash
uv run -- python manage.py runserver 0.0.0.0:8000
```

## 🧪 Testing

Corré los tests con pytest:

```bash
uv run -- pytest
```

## 🧹 Calidad de Código (Linting)

Usamos **Ruff** para mantener el código limpio:

```bash
# Check y Fix automático
uv run -- ruff check --fix .

# Formateo
uv run -- ruff format .
```

## 🐳 Docker

Si preferís correrlo en Docker, usá los comandos desde la raíz del proyecto:

```bash
docker compose up api
```

Podés acceder al panel de admin en `http://localhost:8080/admin` y a la documentación de la API en `http://localhost:8080/api/schema/swagger-ui/`.
