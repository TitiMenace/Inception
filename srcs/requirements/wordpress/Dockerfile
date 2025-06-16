FROM debian:12

# 🧰 Mise à jour et dépendances
RUN apt-get update && apt-get install -y \
    php8.2 \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-cli \
    curl \
    mariadb-client \
    wget \
    unzip \
    less \
    vim \
    ca-certificates \
    && apt-get clean

RUN which php-fpm || echo "php-fpm not found"


RUN ls -l /usr/sbin/php-fpm* && php -v


# 📦 Installation de WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# 📁 Création dossier WordPress
RUN mkdir -p /var/www/html

# Correction de PHP-FPM pour écouter sur 0.0.0.0:9000
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/8.2/fpm/pool.d/www.conf


# 🔐 Copie du script de setup
COPY ./tools/setup_wp.sh /setup_wp.sh
RUN chmod +x /setup_wp.sh

# ⚙️ Dossier d'exécution par défaut
WORKDIR /var/www/html

# 🚀 Lancement du script à l'exécution
CMD ["/setup_wp.sh"]

