FROM wordpress:php8.2-fpm

RUN apt update && apt install -y mariadb-client curl less && rm -rf /var/lib/apt/lists/*

COPY tools/setup_wp.sh /setup_wp.sh
RUN chmod +x /setup_wp.sh

ENTRYPOINT ["sh", "/setup_wp.sh"]
