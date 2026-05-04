#!/bin/bash
set -e

echo "Starting Status Monitor..."

mkdir -p /var/www/status

echo '{"updated":"booting","services":{}}' > /var/www/status/status.json

/monitor.sh &

echo "Starting Nginx..."
exec nginx -g "daemon off;"