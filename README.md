# Backup Solutions

Automated backup scripts and configurations.

## Tools

| Script | Description |
|--------|-------------|
| `proxmox-backup.sh` | VM/CT backups |
| `docker-backup.sh` | Docker volume backups |
| `db-backup.sh` | Database dumps |
| `files-backup.sh` | File backups with rotation |
| `incremental.sh` | Incremental backups |
| `cloud-sync.sh` | Cloud storage sync |
| `encrypt.sh` | GPG encryption |

## Usage

```bash
./proxmox-backup.sh local snapshot
./docker-backup.sh /backups/docker
./db-backup.sh postgres mydb 7
./files-backup.sh /data /backups 30
```

## License

MIT
