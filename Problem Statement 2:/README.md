## 2. Automated Backup Solution:  
Write a script to automate the backup of a specified directory to a remote 
server or a cloud storage solution. The script should provide a report on the 
success or failure of the backup operation.  

---

## Features
- Local backup of files and directories
- Timestamped backup folders
- Automatic deletion of old backups (retention)
- Success/Failure logging

---

## Prerequisites
- Ubuntu or Linux server
- Bash shell
- `rsync` installed

Install `rsync` if not already installed:
```bash
sudo apt update
sudo apt install -y rsync
```
## Setup and Script

Create directories:
```bash
mkdir -p /home/ubuntu/data_to_backup
mkdir -p /home/ubuntu/backups
```

Create the backup script as backup.sh:
```bash
nano backup.sh
```

Paste the following code:
```bash
#!/bin/bash
set -o pipefail

# Configuration
SOURCE_DIR="/home/ubuntu/data_to_backup"
DEST_BASE="/home/ubuntu/backups"
LOGFILE="/var/log/backup.log"
RETENTION_DAYS=7

TIMESTAMP=$(date +'%F_%H-%M-%S')
DEST_DIR="${DEST_BASE}/${TIMESTAMP}"

# Check if source exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "$(date) [ERROR] Source folder not found: $SOURCE_DIR" | tee -a "$LOGFILE"
  exit 1
fi

# Create destination folder
mkdir -p "$DEST_DIR"

# Perform backup
rsync -av --delete "$SOURCE_DIR/" "$DEST_DIR/" >> "$LOGFILE" 2>&1
RC=$?

# Log result
if [ $RC -eq 0 ]; then
  echo "$(date) [OK] Backup successful: $DEST_DIR" | tee -a "$LOGFILE"
else
  echo "$(date) [FAIL] Backup failed (rsync exit $RC)" | tee -a "$LOGFILE"
fi

# Delete old backups
find "$DEST_BASE" -maxdepth 1 -type d -mtime +$RETENTION_DAYS -exec rm -rf {} \; >> "$LOGFILE" 2>&1
```

Make script executable:
```bash
chmod +x backup.sh
```

Test the script manually:
```bash
./backup.sh
```

Check logs:
```bash
tail -n 20 /var/log/backup.log
```
Automation via Cron

To run the backup automatically every day at 2:30 AM:
```bash
crontab -e
```

Add the following line:
```bash
30 2 * * * /home/ubuntu/backup.sh >> /var/log/backup_cron.log 2>&1
```
```bash
ubuntu@ip-172-31-26-18:~$ tree /home/ubuntu/backups/
/home/ubuntu/backups/
├── 2025-09-20_10-20-36
└── 2025-09-20_10-20-44
    ├── file1.txt
    └── file2.txt

3 directories, 2 files
ubuntu@ip-172-31-26-18:~$
```
