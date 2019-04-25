#!/bin/bash

if [ ! -f ".env" ] || [ ! -f ".postgres.env" ]; then
    echo "You must create a .env file and a .postgres.env file to ensure the components are able to authenticate together. See the README for more information."
    exit 1
fi

# Create self-signed ssl cert
if [ ! -f "server.key" ]; then
    openssl req  -nodes -new -x509  -keyout server.key -out server.crt
fi

# Build the containers and start them in detached mode
docker-compose up -d

# Seed the database
docker-compose run vulnreport ruby SEED.rb

echo
echo
echo 'Success! The vulnreport service has started on https://127.0.0.1:443'
echo 'This service is managed with docker-compose. Run `docker-compose down` to stop the services, and `docker-compose up -d` to restart.'

