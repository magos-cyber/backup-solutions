#!/bin/bash
# Proxmox Backup Script
# Backs up all VMs and containers to specified storage

set -euo pipefail

STORAGE="${1:-local}"
MODE="${2:-snapshot}"
BACKUP_DIR="/backups/proxmox/$(date +%Y-%m-%d)"

mkdir -p "$BACKUP_DIR"

echo "=== Proxmox Backup ==="
echo "Storage: $STORAGE"
echo "Mode: $MODE"
echo "Destination: $BACKUP_DIR"

# Backup VMs
echo ""
echo "--- Backing up VMs ---"
for vmid in $(qm list | awk 'NR>1 {print $1}'); do
    echo "Backing up VM $vmid..."
    vzdump "$vmid"         --storage "$STORAGE"         --mode "$MODE"         --compress zstd         --dumpdir "$BACKUP_DIR"         2>&1 | grep -i "progress\|info"
done

# Backup Containers
echo ""
echo "--- Backing up Containers ---"
for ctid in $(pct list | awk 'NR>1 {print $1}'); do
    echo "Backing up CT $ctid..."
    vzdump "$ctid"         --storage "$STORAGE"         --mode "$MODE"         --compress zstd         --dumpdir "$BACKUP_DIR"         2>&1 | grep -i "progress\|info"
done

echo ""
echo "Backup complete: $BACKUP_DIR"
