#!/bin/bash
# Incremental Backup using rsync and hardlinks
# Perfect for daily backups with minimal space

set -euo pipefail

SOURCE="${1:?Usage: $0 <source> <backup_root>}"
BACKUP_ROOT="${2:?Usage: $0 <source> <backup_root>}"

DATE=$(date +%Y-%m-%d)
LATEST="$BACKUP_ROOT/latest"
INCREMENTAL="$BACKUP_ROOT/$DATE"

mkdir -p "$BACKUP_ROOT"

if [ -d "$LATEST" ]; then
    # Hard-link unchanged files from latest
    rsync -aH --delete --link-dest="$LATEST" "$SOURCE/" "$INCREMENTAL/"
else
    rsync -aH "$SOURCE/" "$INCREMENTAL/"
fi

# Update latest symlink
rm -f "$LATEST"
ln -s "$INCREMENTAL" "$LATEST"

# Keep daily snapshots for 7 days
find "$BACKUP_ROOT" -maxdepth 1 -type d -name "20*" -mtime +7 -exec rm -rf {} +

echo "Incremental backup: $INCREMENTAL"
du -sh "$INCREMENTAL"
