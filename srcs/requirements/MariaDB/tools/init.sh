#!/bin/bash
set -e

MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-rootpassword}
MYSQL_DATABASE=${MYSQL_DATABASE:-}
MYSQL_USER=${MYSQL_USER:-}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-}

INIT_FLAG="/var/lib/mysql/.initialized"

echo "Starting entrypoint\n"

if [ ! -f "$INIT_FLAG" ]; then

	echo "init database\n" 

	mysqld_safe --skip-networking &

	while ! mysqladmin ping --silent; do
        sleep 1
  	done

	mysql -u root <<-EOSQL
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
        FLUSH PRIVILEGES;
	EOSQL

	if [ -n "$MYSQL_DATABASE" ]; then
		echo "init mysql data"
		mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<-EOSQL
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
		EOSQL
	fi

	if [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_PASSWORD" ]; then
				echo "init mysql user"
        mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<-EOSQL
            CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
				EOSQL

        if [ -n "$MYSQL_DATABASE" ]; then
					echo "init mysql password"
            mysql -u root -p"${MYSQL_ROOT_PASSWORD}" <<-EOSQL
                GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
                FLUSH PRIVILEGES;
						EOSQL
        fi
    fi

	mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
	touch "INIT_FLAG"
	echo "finish\n"
fi

echo "Starting mariadb\n"

exec mysqld_safe --bind-address=0.0.0.0