#!/bin/bash
apt-get update
apt-get install -y apache2
echo "Welcome ao website do Claudio" > index.html
cp index.html /var/www/html
