FROM debian:bookworm
 
RUN apt-get update && apt-get install -y \
	php-fpm \
	php-mysql \
	wget \
	&& rm -rf /var/lib/apt/lists/*
 
RUN mkdir -p /var/www/adminer \
	&& wget -q https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php \
		-O /var/www/adminer/index.php
 
RUN sed -i 's|listen = /run/php/php.*-fpm.sock|listen = 9001|' /etc/php/*/fpm/pool.d/www.conf
 
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh
 
EXPOSE 9001
 
ENTRYPOINT ["/init.sh"]
 