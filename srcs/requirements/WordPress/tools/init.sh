#!/bin/bash
set -e

INIT_FLAG="/var/www/html/.initialized"

echo "Starting WordPress entrypoint..."

if [ ! -f "$INIT_FLAG" ]; then
	echo "Installing WordPress..."

	echo "Waiting for MariaDB..."
	while ! mysqladmin ping -h"${WORDPRESS_DB_HOST}" -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" --silent 2>/dev/null; do
		sleep 2
	done
	echo "MariaDB is ready."

	wp core download --allow-root --path=/var/www/html

	wp config create \
		--allow-root \
		--path=/var/www/html \
		--dbname="${WORDPRESS_DB_NAME}" \
		--dbuser="${WORDPRESS_DB_USER}" \
		--dbpass="${WORDPRESS_DB_PASSWORD}" \
		--dbhost="${WORDPRESS_DB_HOST}"

	wp core install \
		--allow-root \
		--path=/var/www/html \
		--url="${WORDPRESS_URL}" \
		--title="${WORDPRESS_TITLE}" \
		--admin_user="${WORDPRESS_ADMIN_USER}" \
		--admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
		--admin_email="${WORDPRESS_ADMIN_EMAIL}" \
		--skip-email

	wp user create \
		--allow-root \
		--path=/var/www/html \
		"${WORDPRESS_USER}" "${WORDPRESS_USER_EMAIL}" \
		--user_pass="${WORDPRESS_USER_PASSWORD}" \
		--role=author

	chown -R www-data:www-data /var/www/html

	touch "$INIT_FLAG"
	echo "WordPress setup complete."
fi

echo "Starting php-fpm..."

PHP_FPM=$(find /usr/sbin -name "php-fpm*" | head -n 1)
exec "$PHP_FPM" --nodaemonize