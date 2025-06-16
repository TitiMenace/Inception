#!/bin/sh
set -e

echo "🔧 Lancement de NGINX..."

# Vérifie que les certificats SSL existent
if [ ! -f /etc/ssl/certs/nginx-selfsigned.crt ] || [ ! -f /etc/ssl/private/nginx-selfsigned.key ]; then
    echo "❌ Certificats SSL manquants."
    exit 1
fi

# Lancer NGINX en avant-plan
exec nginx -g "daemon off;"
