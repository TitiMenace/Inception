#!/bin/sh
set -e

echo "📡 Lancement du setup WordPress..."

DB_NAME="wordpress"
DB_USER=$(cat "$DB_USER_FILE")
DB_PASS=$(cat "$DB_PASS_FILE")
DB_HOST="$DB_HOST"

# 🔁 Attente de MariaDB (connexion)
export MYSQL_PWD="$DB_PASS"

until mysqladmin ping -h"$DB_HOST" -u"$DB_USER" --silent; do
    echo "⏳ Attente de MariaDB ($DB_HOST)..."
    sleep 2
done

echo "✅ Connexion à MariaDB réussie."

# Télécharger WordPress si ce n’est pas déjà fait
if [ ! -f /var/www/html/wp-load.php ]; then
  echo "⬇️ Téléchargement de WordPress..."
  wp core download --path=/var/www/html --allow-root
fi


# 🛠 Créer wp-config.php si absent
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "⚙️  Génération de wp-config.php..."

    wp config create \
        --allow-root \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASS" \
        --dbhost="$DB_HOST" \
        --path="/var/www/html"

    echo "✅ wp-config.php généré."
fi

# 🚀 (Optionnel) Installation automatique WordPress
if ! wp core is-installed --allow-root --path="/var/www/html"; then
    echo "📥 Installation de WordPress..."

    wp core install \
        --url="http://localhost" \
        --title="tschecro42" \
        --admin_user="tschecro42" \
        --admin_password="tschecro42" \
        --admin_email="tschecro@example.com" \
        --skip-email \
        --allow-root \
        --path="/var/www/html"

    echo "✅ WordPress installé."
fi

# 🧿 Permissions
chown -R www-data:www-data /var/www/html

# 🚦 Lancer PHP-FPM
echo "🚀 Démarrage de PHP-FPM..."
exec php-fpm8.2 -F

