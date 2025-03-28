#!/bin/bash

podman stop typebot-db typebot-redis typebot-builder typebot-viewer || true
podman rm typebot-db typebot-redis typebot-builder typebot-viewer || true

podman network create typebot-network || true

# Datenbank
podman run -d --name typebot-db \
  --network typebot-network \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_DB=typebot \
  -e POSTGRES_PASSWORD=typebot \
  -v db-data:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:16 postgres -c 'listen_addresses=*'

# Redis
podman run -d --name typebot-redis \
  --network typebot-network \
  -v redis-data:/data \
  -v ./volumes/redis-data:/data \
  -p 6379:6379 \
  redis:alpine --save 60 1 --loglevel warning

echo "Warte 5 Sekunden, bis Datenbank und Redis vollständig gestartet sind..."
sleep 5

# Builder
podman run -d --name typebot-builder \
  --network typebot-network \
  --env-file .env \
  -e REDIS_URL=redis://typebot-redis:6379 \
  -e DATABASE_URL=postgresql://postgres:typebot@typebot-db:5432/typebot \
  -p 8080:3000 \
  baptistearno/typebot-builder:latest

# Viewer
podman run -d --name typebot-viewer \
  --network typebot-network \
  --env-file .env \
  -e REDIS_URL=redis://typebot-redis:6379 \
  -e DATABASE_URL=postgresql://postgres:typebot@typebot-db:5432/typebot \
  -p 8081:3000 \
  baptistearno/typebot-viewer:latest

echo "Typebot wurde gestartet!"
echo "Builder: http://localhost:8080"
echo "Viewer: http://localhost:8081"
