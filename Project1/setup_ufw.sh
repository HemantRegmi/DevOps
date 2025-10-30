#!/bin/bash
# Setup basic UFW firewall rules

sudo apt install ufw -y
sudo ufw allow OpenSSH
sudo ufw enable
sudo ufw status
echo "UFW firewall setup completed."
