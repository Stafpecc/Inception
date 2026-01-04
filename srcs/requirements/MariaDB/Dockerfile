
FROM debian:bookworm

WORKDIR /app

RUN apt-get update && apt-get install -y mariadb-server mariadb-client

COPY tools/init.sh /

RUN chmod +x /init.sh

VOLUME [ "/var/lib/mysql" ]
#persistance des data

EXPOSE 3306

ENTRYPOINT [ "/init.sh" ] 
#voir diff entre Entrypoint et CMD