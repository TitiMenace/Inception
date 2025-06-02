#!/bin/bash
set -e

# Lire les secrets
DB_NAME="wordpress"
DB_USER=$(cat "$DB_USER_FILE")
DB_PASS=$(cat "$DB_PASS_FILE")
DB_HOST="$DB_HOST"

# Attendre que la DB soit prête
until mysqladmin ping -h"$DB_HOST" --silent; do
    echo "⏳ Attente de MariaDB ($DB_HOST)..."
    sleep 2
done

# Aller dans le dossier WordPress
cd /var/www/html

# Télécharger WordPress si vide
if [ ! -f "wp-config.php" ]; then
    echo "📥 Téléchargement de WordPress..."
    wp core download --allow-root

    echo "🔧 Création du fichier wp-config.php"
    wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS --dbhost=$DB_HOST --allow-root

    echo "🧙 Installation de WordPress"
    wp core install --url="localhost" --title="Inception" \
        --admin_user="admin" --admin_password="admin42" \
        --admin_email="admin@example.com" --skip-email --allow-root
fi

# Démarrer php-fpm
echo "✅ WordPress prêt sur :9000"
exec php-fpm
