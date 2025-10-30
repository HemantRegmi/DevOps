#!/bin/bash
# Secure SSH setup for the new user

sudo mkdir -p /home/hemanta/.ssh
sudo chmod 700 /home/hemanta/.ssh
sudo nano /home/hemanta/.ssh/authorized_keys #Paste your public SSH key (e.g., from id_rsa.pub).
sudo chmod 600 /home/hemanta/.ssh/authorized_keys
sudo chown -R hemanta:hemanta /home/hemanta/.ssh
sudo systemctl restart ssh
echo "SSH configured for user 'hemanta'."



