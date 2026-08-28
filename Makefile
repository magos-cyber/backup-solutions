.PHONY: all proxmox docker db files cloud

all: proxmox docker db files

proxmox:
	./scripts/proxmox-backup.sh

docker:
	./scripts/docker-backup.sh

db:
	./scripts/db-backup.sh

files:
	./scripts/files-backup.sh

cloud:
	./scripts/cloud-sync.sh
