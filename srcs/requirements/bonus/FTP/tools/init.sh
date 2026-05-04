#!/bin/bash
set -e

echo "Starting FTP entrypoint..."

# Create FTP user if not exists
if ! id "$FTP_USER" &>/dev/null; then
	echo "Creating FTP user: $FTP_USER"
	useradd -m -d /var/www/html -s /bin/bash "$FTP_USER"
	echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
	chown -R "$FTP_USER":www-data /var/www/html
fi

mkdir -p /var/run/vsftpd/empty

echo "Starting vsftpd..."
exec vsftpd /etc/vsftpd.conf