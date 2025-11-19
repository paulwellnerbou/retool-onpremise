#!/bin/sh

set -e
set -u

SERVER_NAME=$1

mkdir -p nginx

echo "server {
    listen 80;
    server_name ${SERVER_NAME};

    location / {
        proxy_pass http://api:3000;
        
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        #proxy_set_header Upgrade \$http_upgrade;
        #proxy_set_header Connection 'upgrade';
        #proxy_cache_bypass \$http_upgrade;
        #return 301 https://\$server_name\$request_uri;
    }
    location /.well-known/acme-challenge/ {
        alias /var/www/default/challenges/;
        try_files \$uri =404;
    }
}" > ./nginx/retool-80.conf
