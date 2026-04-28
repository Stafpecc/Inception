FROM debian:bookworm
 
WORKDIR /var/www/html
 
RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    php-curl \
    php-gd \
    php-intl \
    php-mbstring \
    php-soap \
    php-xml \
    php-xmlrpc \
    php-zip \
    wget \
    curl \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*
 
RUN wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp
 
RUN sed -i 's|listen = /run/php/php.*-fpm.sock|listen = 9000|' /etc/php/*/fpm/pool.d/www.conf \
	&& sed -i 's|;listen.owner = www-data|listen.owner = www-data|' /etc/php/*/fpm/pool.d/www.conf \
	&& sed -i 's|;listen.group = www-data|listen.group = www-data|' /etc/php/*/fpm/pool.d/www.conf
 
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh
 
EXPOSE 9000
 
ENTRYPOINT ["/init.sh"]
 