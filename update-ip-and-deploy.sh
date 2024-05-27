#!/bin/bash

# Fetch the current public DNS from the EC2 metadata
PUBLIC_DNS=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4) #//public-hostname
echo "Current public DNS: $PUBLIC_DNS"

# Check if .env file exists, if not, create it
if [ ! -f .env ]; then
    echo "Creating .env file..."
    touch .env
fi

# Update environment variables with the new public DNS
echo "Updating .env file..."
sed -i "s|^REACT_APP_SOCKET_URL=.*|REACT_APP_SOCKET_URL=http://$PUBLIC_DNS:3000|" .env
sed -i "s|^CORS_ORIGIN=.*|CORS_ORIGIN=http://$PUBLIC_DNS:5174|" .env

# Ensure that the .env file includes these variables, add if not present
if ! grep -q "REACT_APP_SOCKET_URL=" .env; then
    echo "REACT_APP_SOCKET_URL=http://$PUBLIC_DNS:3000" >> .env
fi

if ! grep -q "CORS_ORIGIN=" .env; then
    echo "CORS_ORIGIN=http://$PUBLIC_DNS:5174" >> .env
fi

# Deployment commands
echo "Starting Docker services..."
sudo service docker start
docker-compose build
docker-compose up -d

echo "Your application is now accessible at http://$PUBLIC_DNS"
