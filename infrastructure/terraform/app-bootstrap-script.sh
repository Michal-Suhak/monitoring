#!/bin/bash
# Logs
exec > >(tee /var/log/bootstrap.log | logger -t bootstrap) 2>&1
echo "Bootstrap script started"

# Update packages
apt update
apt install -y python3-pip
apt install -y python3-poetry

# clone app code
git init app
cd app || exit
git remote add origin https://github.com/Michal-Suhak/monitoring.git
git config core.sparseCheckout true

# Get app directory
echo "app/" >> .git/info/sparse-checkout
git pull origin main
cd app || exit


# Install dependencies and run app
pwd

poetry install
poetry run fastapi run app.py