#!/bin/bash
# Database Backup Script
# Supports PostgreSQL, MySQL, MongoDB

set -euo pipefail

DB_TYPE="${1:-postgres}"
DB_NAME="${2:-all}"
ROTATE_DAYS="${3:-7}"
BACKUP_DIR="/backups/db/$(date +%Y-%m-%d)"

mkdir -p "$BACKUP_DIR"

echo "=== Database Backup ==="
echo "Type: $DB_TYPE"
echo "Database: $DB_NAME"
echo "Rotation: $ROTATE_DAYS days"

case "$DB_TYPE" in
    postgres)
        if [ "$DB_NAME" = "all" ]; then
            sudo -u postgres pg_dumpall > "$BACKUP_DIR/all.sql"
        else
            sudo -u postgres pg_dump "$DB_NAME" > "$BACKUP_DIR/${DB_NAME}.sql"
        fi
        gzip "$BACKUP_DIR"/*.sql
        ;;
    mysql)
        if [ "$DB_NAME" = "all" ]; then
            mysqldump -u root -p --all-databases > "$BACKUP_DIR/all.sql"
        else
            mysqldump -u root -p "$DB_NAME" > "$BACKUP_DIR/${DB_NAME}.sql"
        fi
        gzip "$BACKUP_DIR"/*.sql
        ;;
    mongo)
        mongodump --db "$DB_NAME" --out "$BACKUP_DIR/mongo"
        tar -czf "$BACKUP_DIR/mongo.tar.gz" -C "$BACKUP_DIR" mongo
        rm -rf "$BACKUP_DIR/mongo"
        ;;
    *)
        echo "Unknown database type: $DB_TYPE"
        exit 1
        ;;
esac

# Rotation
echo "Cleaning up old backups..."
find "$BACKUP_DIR/.." -name "*.sql.gz" -mtime +"$ROTATE_DAYS" -delete
find "$BACKUP_DIR/.." -name "*.tar.gz" -mtime +"$ROTATE_DAYS" -delete

echo "Database backup complete"
