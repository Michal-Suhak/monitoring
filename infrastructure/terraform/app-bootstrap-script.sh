#!/bin/bash
# Logs
exec > >(tee /var/log/bootstrap.log | logger -t bootstrap) 2>&1
echo "Bootstrap script started"

# Update packages
apt update
apt upgrade -y
apt install -y python3-pip
apt install -y python3-poetry

# Install Cloud Watch Agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
dpkg -i amazon-cloudwatch-agent.deb

# Clone app code
git init app
cd app || exit
git remote add origin https://github.com/Michal-Suhak/monitoring.git
git config core.sparseCheckout true

# Get app directory
echo "app/" >> .git/info/sparse-checkout
git pull origin main
cd app || exit

# Create FastAPI logs directory
mkdir -p /var/log/fastapi
touch /var/log/fastapi/fastapi.log
chmod 644 /var/log/fastapi/fastapi.log

# Run CloudWatch agent
# Configuration can be stored in the parameter store I use file due to financial considerations
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/app/app/cloud-watch-agent-config.json \
  -s

# Install dependencies and run app
poetry install
poetry run uvicorn monitoring.main:app --host 0.0.0.0 --port 8000 --reload