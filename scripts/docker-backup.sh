#!/bin/bash
# Docker Backup Script
# Backs up Docker volumes and compose files

set -euo pipefail

OUTPUT_DIR="${1:-/backups/docker/$(date +%Y-%m-%d)}"
COMPOSE_DIR="${2:-/opt/docker}"

mkdir -p "$OUTPUT_DIR"

echo "=== Docker Backup ==="
echo "Output: $OUTPUT_DIR"
echo "Compose dir: $COMPOSE_DIR"

# Backup compose files
echo "Backing up compose files..."
if [ -d "$COMPOSE_DIR" ]; then
    tar -czf "$OUTPUT_DIR/compose-files.tar.gz" -C "$COMPOSE_DIR" .
fi

# Backup volumes
echo "Backing up volumes..."
docker volume ls -q | while read volume; do
    echo "  Volume: $volume"
    docker run --rm         -v "$volume":/data:ro         -v "$OUTPUT_DIR":/backup         alpine tar -czf "/backup/${volume}.tar.gz" -C /data .
done

# Backup running container list
echo "Saving container list..."
docker ps -a --format "table {{.Names}}	{{.Image}}	{{.Status}}" > "$OUTPUT_DIR/containers.txt"

echo ""
echo "Docker backup complete: $OUTPUT_DIR"
