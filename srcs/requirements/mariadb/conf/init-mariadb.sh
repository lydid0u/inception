#!/bin/bash

# Démarrage du service MySQL
service mysql start

# Création d'un fichier SQL contenant les commandes SQL nécessaires pour configurer la base de données et les utilisateurs
echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE ;" > db1.sql
echo "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' ;" >> db1.sql
echo "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' ;" >> db1.sql
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' ;" >> db1.sql
echo "FLUSH PRIVILEGES;" >> db1.sql

# Exécution des commandes SQL à l'aide de l'outil mysql en passant le contenu du fichier SQL
mysql -uroot -p$MYSQL_ROOT_PASSWORD < db1.sql

# Arrêt du service MySQL en tuant le processus
kill $(cat /var/run/mysqld/mysqld.pid)

# Démarrage de mysqld
mysqld
