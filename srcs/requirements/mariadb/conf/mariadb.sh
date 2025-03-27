#!/bin/bash

#on demarre la db, on la configure, on arrete mysql puis on le redemarre avec les config essentielle
#on redemarre pour avoir un demarage propre avec mysql_safe avec la config precise quon lui donne

service mysql start
until mysql -e "SELECT 1" &>/dev/null
do
  echo "Waiting for mariadb to start..."
  sleep 1
done

mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mysql -e "FLUSH PRIVILEGES;"

mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown

mysqld_safe --port=3306 --bind-address=0.0.0.0 --socket='/run/mysqld/mysqld.sock' --user=mysql --datadir='/var/lib/mysql'