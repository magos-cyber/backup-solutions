#!/bin/bash
# GPG Encryption for Backups
# Encrypts backup archives

set -euo pipefail

INPUT="${1:?Usage: $0 <file> <recipient>}"
RECIPIENT="${2:?Usage: $0 <file> <recipient>}"

echo "=== GPG Encryption ==="
echo "Input: $INPUT"
echo "Recipient: $RECIPIENT"

if ! command -v gpg &>/dev/null; then
    echo "ERROR: gpg not installed"
    exit 1
fi

gpg --encrypt --recipient "$RECIPIENT" --output "${INPUT}.gpg" "$INPUT"

echo "Encrypted: ${INPUT}.gpg"
