# Backup Solutions

Automated backup scripts and configurations for homelab infrastructure.

## Features

- Proxmox VM/LXC backups
- Docker volume backups
- Database dumps (PostgreSQL, MySQL, MongoDB)
- File system backups with rotation
- Incremental backups
- Cloud sync (rclone)
- Encrypted backups (GPG)

## Tools

| Script | Description |
|--------|-------------|
| `proxmox-backup.sh` | Full/inc backup of VMs and containers |
| `docker-backup.sh` | Backup Docker volumes and compose files |
| `db-backup.sh` | Database dumps with rotation |
| `files-backup.sh` | rsync-based file backups |
| `incremental.sh` | Incremental backup using hardlinks |
| `cloud-sync.sh` | Sync to cloud storage via rclone |
| `encrypt.sh` | GPG-encrypt backups |

## Usage

```bash
# Proxmox backup
./proxmox-backup.sh --storage local --mode snapshot

# Docker volumes
./docker-backup.sh --output /backups/docker

# Database dump
./db-backup.sh --type postgres --db mydb --rotate 7

# File backup with rotation
./files-backup.sh --source /data --dest /backups --keep 30
```

## Retention Policy

Default retention: 30 days daily, 12 weekly, 12 monthly

## License

MIT
