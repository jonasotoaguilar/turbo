#!/bin/sh

apply_migrations() {
  echo "Applying database migrations..."
  uv run python manage.py migrate
}

apply_fixtures() {
  echo "Applying Django fixtures..."
  for fixture in fixtures/dev/*.json; do
    if [ -f "$fixture" ]; then
      echo "Loading $fixture"
      uv run python manage.py loaddata "$fixture"
    fi
  done
}

start_dev_server() {
  echo "Starting the development server..."
  uv run python manage.py runserver 0.0.0.0:"${DJANGO_PORT:-8080}"
}

start_prod_server() {
  echo "Starting the Gunicorn server..."
  uv run gunicorn --bind 0.0.0.0:8000 --workers 4 config.wsgi:application
}

case "$1" in
  dev)
    apply_migrations
    apply_fixtures
    start_dev_server
    ;;
  prod)
    apply_migrations
    start_prod_server
    ;;
  *)
    echo "Usage: $0 {dev|prod}"
    exit 1
    ;;
esac
