#!/bin/bash
set -e

# Colores para la salida
GREEN='\033[0;32m'
NC='\033[0m' # No Color
YELLOW='\033[1;33m'

# Asegurar que estamos en la raíz del proyecto
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT" || exit 1

echo -e "${YELLOW}Configurando archivo .env...${NC}"

# Root env
if [ ! -f .env ]; then
    echo -e "Creando .env desde template..."
    cp .env.template .env
else
    echo -e ".env ya existe, omitiendo."
fi

echo -e "${GREEN}✅ Archivo .env configurado.${NC}"
