#!/bin/bash
set -e
 
echo "Starting Adminer..."
PHP_FPM=$(find /usr/sbin -name "php-fpm*" | head -n 1)
exec "$PHP_FPM" --nodaemonize
 