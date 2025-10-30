#!/bin/bash

# Log Backup and Rotation Script
# Author: Hemanta Regmi


# Set variables
LOG_SRC="/var/log"                     # Source logs directory
BACKUP_DIR="/var/log/backups"          # Backup destination
DATE=$(date +"%Y-%m-%d_%H-%M-%S")     # Timestamp for each backup
RETENTION_DAYS=7                       # Keep backups for 7 days

# Create backup filename
BACKUP_FILE="$BACKUP_DIR/logs_$DATE.tar.gz"

# Compress logs
tar -czf "$BACKUP_FILE" $LOG_SRC/*.log 2>/dev/null

# Check if compression succeeded
if [ $? -eq 0 ]; then
    echo "[$(date)] Backup created: $BACKUP_FILE" >> /var/log/backup_script.log
else
    echo "[$(date)] Backup FAILED" >> /var/log/backup_script.log
fi

# Delete old backups (older than RETENTION_DAYS)
find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +$RETENTION_DAYS -exec rm {} \;

# Log cleanup activity
echo "[$(date)] Old backups deleted (older than $RETENTION_DAYS days)" >> /var/log/backup_script.log
