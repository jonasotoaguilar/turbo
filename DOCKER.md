# Docker Setup

Este proyecto incluye configuraciones de Docker Compose para desarrollo y producción.

## 🚀 Desarrollo

Para desarrollo local con hot-reload:

```bash
# Levantar servicios
docker compose -f docker-compose-dev.yml up

# Rebuild si cambiaste dependencias
docker compose -f docker-compose-dev.yml up --build

# Bajar servicios
docker compose -f docker-compose-dev.yml down

# Bajar y limpiar volúmenes
docker compose -f docker-compose-dev.yml down -v
```

### Servicios de desarrollo

- **api-dev**: Django con runserver en puerto `${DJANGO_PORT:-8080}`
  - Aplica migraciones automáticamente
  - Carga fixtures de `backend/fixtures/dev/*.json`
  - Hot-reload habilitado
- **ui-dev**: Next.js dev server en puerto `3000`
  - Hot-reload habilitado
- **postgres**: PostgreSQL 16.3

### Fixtures de desarrollo

Para agregar datos iniciales:

```bash
# Exportar datos actuales
docker compose -f docker-compose-dev.yml exec api-dev uv run python manage.py dumpdata auth.User --indent 2 > backend/fixtures/dev/users.json

# Se cargarán automáticamente al reiniciar el contenedor
```

## 📦 Producción

Para producción con imágenes optimizadas:

```bash
# Build y levantar servicios
docker compose up --build

# Solo levantar (usa imágenes pre-buildeadas)
docker compose up

# Bajar servicios
docker compose down
```

### Servicios de producción

- **api**: Django con Gunicorn en puerto `${DJANGO_PORT:-8080}`
  - Aplica migraciones automáticamente
  - Optimizado para producción
- **ui**: Next.js standalone build en puerto `${UI_PORT:-3000}`
  - Optimizado con multi-stage build
- **postgres**: PostgreSQL 16.3

### Build y push de imágenes

```bash
# Build de imágenes
docker compose build

# Tag y push a registry (GitHub Container Registry por defecto)
docker tag api:latest ${DOCKER_REGISTRY}/${DOCKER_NAMESPACE}/api:${API_VERSION}
docker tag ui:latest ${DOCKER_REGISTRY}/${DOCKER_NAMESPACE}/ui:${UI_VERSION}

docker push ${DOCKER_REGISTRY}/${DOCKER_NAMESPACE}/api:${API_VERSION}
docker push ${DOCKER_REGISTRY}/${DOCKER_NAMESPACE}/ui:${UI_VERSION}
```

## 🔧 Variables de entorno

Copiá `.env.template` a `.env` y ajustá los valores:

```bash
cp .env.template .env
```

El archivo `.env` está organizado en secciones:

### Database Configuration

- `POSTGRES_HOST`: Hostname de PostgreSQL (default: postgres-db)
- `POSTGRES_PORT`: Puerto de PostgreSQL (default: 5432)
- `POSTGRES_ADMIN_USER`: Usuario admin de PostgreSQL
- `POSTGRES_ADMIN_PASSWORD`: Password del admin
- `POSTGRES_USER`: Usuario de la aplicación
- `POSTGRES_PASSWORD`: Password del usuario
- `POSTGRES_DB`: Nombre de la base de datos

### Backend (Django) Configuration

- `DEBUG`: Modo debug (True para dev, False para prod)
- `SECRET_KEY`: Secret key de Django (cambiar en producción)
- `DJANGO_SETTINGS_MODULE`: Módulo de settings (default: config.django.devel)
- `DJANGO_PORT`: Puerto del API (default: 8080)
- `LOGGING_FORMATTER`: Formato de logs (human_readable o json)

### Frontend (Next.js) Configuration

- `API_URL`: URL del backend (http://api-dev:8080 en dev, http://api:8000 en prod)
- `NEXTAUTH_URL`: URL de NextAuth (default: http://localhost:3000/api/auth)
- `NEXTAUTH_SECRET`: Secret de NextAuth (cambiar en producción)
- `UI_PORT`: Puerto del frontend (default: 3000)

### Docker Registry (for production builds)

- `DOCKER_REGISTRY`: Registry de Docker (default: ghcr.io)
- `DOCKER_NAMESPACE`: Namespace/usuario (default: jonasotoaguilar)
- `API_VERSION`: Tag de versión del API (default: latest)
- `UI_VERSION`: Tag de versión del UI (default: latest)

## 📁 Estructura de datos

Los datos persistentes se guardan en `_data/`:

```
_data/
├── api/          # Configuración del API
└── postgres/     # Base de datos PostgreSQL
```

Este directorio está en `.gitignore` y se crea automáticamente.

## 🐛 Troubleshooting

### Permisos en volúmenes

Si tenés problemas de permisos:

```bash
sudo chown -R $USER:$USER _data/
```

### Limpiar todo

Para empezar de cero:

```bash
docker compose -f docker-compose-dev.yml down -v
rm -rf _data/
```

### Ver logs

```bash
# Todos los servicios
docker compose -f docker-compose-dev.yml logs -f

# Un servicio específico
docker compose -f docker-compose-dev.yml logs -f api-dev
```
