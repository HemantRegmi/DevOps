#!/bin/bash
# upload-logs.sh
# Archive and upload logs to versioned S3 bucket

BUCKET="w3p5"                       # Your S3 bucket name
LOG_DIR="/var/log"                  # Directory to collect logs from
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
ARCHIVE="/tmp/logs_$TIMESTAMP.tar.gz"

echo "Compressing logs from $LOG_DIR ..."
tar -czf $ARCHIVE $LOG_DIR

echo "Uploading archive to S3 bucket: $BUCKET ..."
aws s3 cp $ARCHIVE s3://$BUCKET/logs/logs_$TIMESTAMP.tar.gz

if [ $? -eq 0 ]; then
    echo "Successfully uploaded logs_$TIMESTAMP.tar.gz to S3."
    rm -f $ARCHIVE
else
    echo "Upload failed!"
fi
