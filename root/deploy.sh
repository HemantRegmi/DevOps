#!/bin/bash
set -e
APP_DIR=/home/ubuntu/myapp
cd $APP_DIR

echo "Installing Node and Python dependencies..."
npm install --production || true    
pip3 install -r requirements.txt || true

echo "Restarting myapp service..."
sudo systemctl restart myapp || {
  echo "systemd start failed, launching with nohup"
  nohup node server.js > app.log 2>&1 &
}
echo "Deployment finished"
