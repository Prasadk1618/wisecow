#!/bin/bash
set -o pipefail

# ----- CONFIG -----
SOURCE_DIR="/home/ubuntu/data_to_backup"          
DEST_BASE="/home/ubuntu/backups"                 
LOGFILE="/var/log/backup.log"                    
RETENTION_DAYS=7                                 
# -------------------

# Timestamp 
TIMESTAMP=$(date +'%F_%H-%M-%S')
DEST_DIR="${DEST_BASE}/${TIMESTAMP}"

# Source directory check
if [ ! -d "$SOURCE_DIR" ]; then
  echo "$(date) [ERROR] Source folder not found: $SOURCE_DIR" | tee -a "$LOGFILE"
  exit 1
fi

# Destination folder 
mkdir -p "$DEST_DIR"

# Backup command
rsync -av --delete "$SOURCE_DIR/" "$DEST_DIR/" >> "$LOGFILE" 2>&1
RC=$?

# Success / Failure log
if [ $RC -eq 0 ]; then
  echo "$(date) [OK] Backup successful: $DEST_DIR" | tee -a "$LOGFILE"
else
  echo "$(date) [FAIL] Backup failed (rsync exit $RC)" | tee -a "$LOGFILE"
fi

# Old backups delete 
find "$DEST_BASE" -maxdepth 1 -type d -mtime +$RETENTION_DAYS -exec rm -rf {} \; >> "$LOGFILE" 2>&1
