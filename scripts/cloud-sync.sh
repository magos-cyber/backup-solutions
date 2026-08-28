#!/bin/bash
# Cloud Sync Script using rclone
# Syncs local backups to cloud storage

set -euo pipefail

LOCAL_DIR="${1:?Usage: $0 <local_dir> <remote_name:remote_path>}"
REMOTE="${2:?Usage: $0 <local_dir> <remote_name:remote_path>}"

echo "=== Cloud Sync ==="
echo "Local: $LOCAL_DIR"
echo "Remote: $REMOTE"

# Check rclone installed
if ! command -v rclone &>/dev/null; then
    echo "ERROR: rclone not installed"
    exit 1
fi

# Sync with deletion
rclone sync "$LOCAL_DIR" "$REMOTE"     --transfers 4     --checkers 8     --progress     --log-file=/var/log/cloud-sync.log

echo "Cloud sync complete"
