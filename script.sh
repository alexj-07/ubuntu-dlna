#!/bin/bash

# Comprobar si la imagen Owncast existe localmente
if docker image inspect owncast:latest >/dev/null 2>&1; then
  echo "La imagen Owncast existe localmente."
else
  echo "La imagen Owncast no se encontró localmente. Descargando..."
  docker pull owncast/owncast:latest
fi

# Detener y eliminar cualquier contenedor Owncast existente
docker stop owncast-container >/dev/null 2>&1
docker rm owncast-container >/dev/null 2>&1

# Crear volúmenes para almacenar los datos persistentes del contenedor
docker volume create owncast-data >/dev/null 2>&1

# Iniciar el contenedor Owncast
docker run -d -p 8084:8080 -p 1935:1935 \
  -v owncast-data:/app/data \
  -v $(pwd)/videos-owncast:/app/videos \
  --name owncast-container \
  owncast/owncast:latest

echo "El contenedor Owncast se ha iniciado correctamente."
