FROM debian:12

RUN apt update && apt install -y mariadb-server
RUN apt-get update && apt-get install -y mariadb-server passwd

COPY tools/startdb.sh /startdb.sh
RUN chmod +x /startdb.sh

COPY ./conf/50-bind.cnf /etc/mysql/mariadb.conf.d/50-bind.cnf


CMD ["/startdb.sh"]
