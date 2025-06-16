FROM debian:12

# Installation de NGINX et OpenSSL
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copie du script de démarrage
COPY tools/start_nginx.sh /start_nginx.sh
RUN chmod +x /start_nginx.sh

# Copie du fichier de configuration principal de nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Génération du certificat SSL auto-signé
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/CN=localhost"

# Exposition du port HTTPS
EXPOSE 443

# Commande de démarrage
CMD ["/start_nginx.sh"]
