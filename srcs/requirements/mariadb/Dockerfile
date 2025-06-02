FROM debian:12.10

RUN apt update && apt -y upgrade && \
    apt install -y mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/*

COPY ./tools/startdb.sh /startdb.sh

RUN chmod +x /startdb.sh

EXPOSE 3306

CMD ["sh", "/startdb.sh"]

