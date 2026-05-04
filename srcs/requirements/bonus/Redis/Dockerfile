FROM debian:bookworm
 
RUN apt-get update && apt-get install -y \
	redis-server \
	&& rm -rf /var/lib/apt/lists/*
 
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh
 
EXPOSE 6379
 
ENTRYPOINT ["/init.sh"]
 