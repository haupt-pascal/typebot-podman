#!/bin/bash
# Author: Pascal Haupt
# Script to deploy Typebot using Podman

# Error handling
set -e  # Exit immediately if a command exits with a non-zero status
trap 'echo "Error: Script execution failed"; exit 1' ERR

# Check if .env file exists
if [ ! -f .env ]; then
    echo "Error: .env file not found. Please create it before running this script."
    exit 1
fi

# Create the pod if it doesn't exist
if ! podman pod exists typebot-pod; then
    echo "Creating typebot pod..."
    podman pod create --name typebot-pod -p 8080:3000 -p 8081:3000
fi

echo "Starting PostgreSQL database..."
if ! podman run -d --pod typebot-pod \
  --name typebot-db \
  -v ./volumes/db-data:/var/lib/postgresql/data:Z \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_DB=typebot \
  -e POSTGRES_PASSWORD=typebot \
  postgres:16 postgres -c 'listen_addresses=*'; then
    echo "Error: Failed to start PostgreSQL database"
    exit 1
fi

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL..."
sleep 5

echo "Starting Redis..."
if ! podman run -d --pod typebot-pod \
  --name typebot-redis \
  -v ./volumes/redis-data:/data:Z \
  redis:alpine --save 60 1 --loglevel warning; then
    echo "Error: Failed to start Redis"
    exit 1
fi

sleep 3

source .env

echo "Starting Typebot Builder..."
if ! podman run -d --pod typebot-pod \
  --name typebot-builder \
  --env-file .env \
  -e REDIS_URL=redis://127.0.0.1:6379 \
  baptistearno/typebot-builder:latest; then
    echo "Error: Failed to start Typebot Builder"
    exit 1
fi

echo "Starting Typebot Viewer..."
if ! podman run -d --pod typebot-pod \
  --name typebot-viewer \
  --env-file .env \
  -e REDIS_URL=redis://127.0.0.1:6379 \
  baptistearno/typebot-viewer:latest; then
    echo "Error: Failed to start Typebot Viewer"
    exit 1
fi

# Print success message and access information
echo "Typebot stack has been successfully started!"
echo "Builder is accessible at: http://localhost:8080"
echo "Viewer is accessible at: http://localhost:8081"
echo ""
echo "Container status:"
podman pod ps
podman ps -a --pod

echo "Setup completed."
