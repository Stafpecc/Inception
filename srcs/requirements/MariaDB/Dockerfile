FROM debian:bookworm

WORKDIR /app

RUN apt-get update && apt-get install -y mariadb-server mariadb-client

COPY tools/init.sh /

RUN chmod +x /init.sh

VOLUME [ "/var/lib/mysql" ]

EXPOSE 3306

ENTRYPOINT [ "/init.sh" ] 
