#!/bin/bash
# Install and enable auditd for logging

sudo apt install auditd -y
sudo systemctl enable auditd
sudo systemctl start auditd
echo "auditd installed and enabled."

