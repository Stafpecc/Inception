#!/bin/bash
set -e
 
SSL_DIR="/etc/nginx/ssl"
DOMAIN="tarini.42.fr"
 
echo "Starting Nginx entrypoint..."
 
if [ ! -f "$SSL_DIR/$DOMAIN.crt" ]; then
	echo "Generating SSL certificate..."
	mkdir -p "$SSL_DIR"
	openssl req -x509 -nodes -days 365 \
		-newkey rsa:2048 \
		-keyout "$SSL_DIR/$DOMAIN.key" \
		-out "$SSL_DIR/$DOMAIN.crt" \
		-subj "/C=FR/ST=Paris/L=Paris/O=42/OU=tarini/CN=$DOMAIN"
	echo "SSL certificate generated."
fi
 
echo "Starting Nginx..."
exec nginx -g "daemon off;"
 #!/bin/bash
set -e
 
SSL_DIR="/etc/nginx/ssl"
DOMAIN="tarini.42.fr"
 
echo "Starting Nginx entrypoint..."
 
if [ ! -f "$SSL_DIR/$DOMAIN.crt" ]; then
	echo "Generating SSL certificate..."
	mkdir -p "$SSL_DIR"
	openssl req -x509 -nodes -days 365 \
		-newkey rsa:2048 \
		-keyout "$SSL_DIR/$DOMAIN.key" \
		-out "$SSL_DIR/$DOMAIN.crt" \
		-subj "/C=FR/ST=Paris/L=Paris/O=42/OU=tarini/CN=$DOMAIN"
	echo "SSL certificate generated."
fi
 
echo "Starting Nginx..."
exec nginx -g "daemon off;"
 
