FROM debian:bookworm
 
RUN apt-get update && apt-get install -y \
	curl \
	nginx \
	netcat-openbsd \
	&& rm -rf /var/lib/apt/lists/*
 
COPY www/ /var/www/status/
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/monitor.sh /monitor.sh
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh /monitor.sh
 
EXPOSE 8080
 
ENTRYPOINT ["/init.sh"]