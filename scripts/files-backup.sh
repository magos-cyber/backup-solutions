#!/bin/bash
# File Backup Script with Rotation
# Uses rsync with hardlinks for incremental backups

set -euo pipefail

SOURCE="${1:?Usage: $0 <source> <dest> [keep_days]}"
DEST="${2:?Usage: $0 <source> <dest> [keep_days]}"
KEEP_DAYS="${3:-30}"

BACKUP_NAME=$(date +%Y-%m-%d_%H-%M-%S)
CURRENT="$DEST/current"
SNAPSHOT="$DEST/snapshots/$BACKUP_NAME"

mkdir -p "$DEST/snapshots"

echo "=== File Backup ==="
echo "Source: $SOURCE"
echo "Destination: $DEST"
echo "Keep: $KEEP_DAYS days"

# Rsync with hardlinks to previous backup
if [ -d "$CURRENT" ]; then
    rsync -aH --delete --link-dest="$CURRENT" "$SOURCE/" "$SNAPSHOT/"
else
    rsync -aH "$SOURCE/" "$SNAPSHOT/"
fi

# Update current symlink
rm -f "$CURRENT"
ln -s "$SNAPSHOT" "$CURRENT"

# Rotation
find "$DEST/snapshots" -maxdepth 1 -type d -mtime +"$KEEP_DAYS" -exec rm -rf {} +

echo "Backup complete: $SNAPSHOT"
