#!/bin/bash
set -e

# Lire les secrets depuis le volume monté
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password.txt)
MYSQL_USER=$(cat /run/secrets/credentials.txt)
MYSQL_PASSWORD=$(cat /run/secrets/db_password.txt)
MYSQL_DATABASE="wordpress"

# Démarre temporairement le serveur en arrière-plan
mysqld_safe --skip-networking &
pid="$!"

# Attendre que MariaDB soit prêt
until mysqladmin ping --silent; do
    echo "⏳ En attente de MariaDB..."
    sleep 1
done

# Exécute les commandes de création
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Arrête le processus temporaire
kill -s TERM "$pid"
wait "$pid"

# Redémarre le serveur proprement
exec mysqld_safe


