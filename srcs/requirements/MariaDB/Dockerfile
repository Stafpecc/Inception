
# Bullseye debian 11 --> Penultimate stable
# Bookworm debian 12 --> Stable
# Trixie   debian 13 --> TestingFROM debian:bullseye

FROM debian:bullseye

WORKDIR /app

RUN apt-get update && apt-get install -y mariadb-server mariadb-client

COPY tools/ /docker-entrypoint-initdb.d/

EXPOSE 3306

CMD ["mysqld_safe"]