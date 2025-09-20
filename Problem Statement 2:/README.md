# Automated Local Backup Script

This is a simple **Bash script** to automate the backup of a specified directory on a single server.  
The script copies files from a **source directory** to a **backup directory** with a timestamp, maintains logs, and automatically deletes backups older than a configured number of days. It also allows easy automation via cron.

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
