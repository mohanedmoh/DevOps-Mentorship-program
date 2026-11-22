#!/bin/bash
set -euo pipefail

dnf install -y httpd

# Ask the instance metadata service (version 2) who we are.
TOKEN=$(curl -sS -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 300")
INSTANCE_ID=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
ZONE=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone)

cat > /var/www/html/index.html <<HTML
<!doctype html>
<html lang="en">
<head><meta charset="utf-8"><title>Mentorship demo</title></head>
<body>
  <h1>It works</h1>
  <p>Instance: $INSTANCE_ID</p>
  <p>Zone: $ZONE</p>
</body>
</html>
HTML

systemctl enable --now httpd
