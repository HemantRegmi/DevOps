#!/bin/bash
# Create new user and grant sudo privileges

sudo adduser hemanta
sudo usermod -aG sudo hemanta
echo "User 'hemanta' created and added to sudo group."
