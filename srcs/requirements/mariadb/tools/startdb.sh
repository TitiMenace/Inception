#!/bin/sh
set -e

echo "⏳ Démarrage MariaDB..."

# Crée le dossier du socket s’il n’existe pas
mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

# Assure les droits corrects sur le datadir
chown -R mysql:mysql /var/lib/mysql

# Lancer mysqld avec la config personnalisée (bind sur 0.0.0.0)
su -s /bin/sh mysql -c "mysqld --defaults-file=/etc/mysql/mariadb.conf.d/50-bind.cnf --datadir=/var/lib/mysql" &

# Attente que MariaDB soit prêt
while ! mysqladmin ping --silent --user=root; do
    echo "⏳ MariaDB pas encore prêt..."
    sleep 1
done

DB_NAME="wordpress"
DB_USER=$(cat /run/secrets/credentials.txt)
DB_PASS=$(cat /run/secrets/db_password.txt)

echo "✅ Initialisation de la base..."
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
FLUSH PRIVILEGES;
EOF

echo "✅ MariaDB prêt."

wait

