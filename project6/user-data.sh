#!/bin/bash
apt update -y
apt install -y nginx

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head><title>My Nginx Site</title></head>
<body style="font-family: Arial; text-align:center; margin-top:100px;">
<h1>Welcome to My EC2 Static Site </h1>
<p>Deployed automatically using cloud-init by Hemant Regmi</p>
</body>
</html>
EOF

systemctl enable nginx
systemctl start nginx
