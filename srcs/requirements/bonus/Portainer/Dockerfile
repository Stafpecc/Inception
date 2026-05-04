FROM debian:bookworm

RUN apt-get update && apt-get install -y \
	wget \
	ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

RUN wget -q https://github.com/portainer/portainer/releases/download/2.19.4/portainer-2.19.4-linux-amd64.tar.gz \
	&& tar -xzf portainer-2.19.4-linux-amd64.tar.gz \
	&& rm portainer-2.19.4-linux-amd64.tar.gz

EXPOSE 9000

CMD ["./portainer/portainer"]