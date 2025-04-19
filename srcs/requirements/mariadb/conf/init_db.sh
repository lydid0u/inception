#!/bin/bash

# Ensure MySQL directory is set up properly
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB service temporarily to configure
service mysql start

# Wait for MariaDB to be ready
while ! mysqladmin ping -h localhost --silent; do
    echo "Waiting for MariaDB to start..."
    sleep 1
done

# Initialize databases and users
echo "Setting up database and users..."

# Create database and user if they don't exist
mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"

# Set root password and secure the database
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mysql -e "DROP DATABASE IF EXISTS test;"
mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
mysql -e "FLUSH PRIVILEGES;"

# Stop the service as we will restart it in the foreground
service mysql stop

echo "Database setup completed."

# Start MariaDB in the foreground
exec mysqld_safe

# #!/bin/bash

# #on demarre la db, on la configure, on arrete mysql puis on le redemarre avec les config essentielle
# #on redemarre pour avoir un demarage propre avec mysql_safe avec la config precise quon lui donne

# service mysql start
# until mysql -e "SELECT 1" &>/dev/null
# do
#   echo "Waiting for mariadb to start..."
#   sleep 1
# done

# mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
# mysql -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
# mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
# mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
# mysql -e "FLUSH PRIVILEGES;"

# mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown

# mysqld_safe --port=3306 --bind-address=0.0.0.0 --socket='/run/mysqld/mysqld.sock' --user=mysql --datadir='/var/lib/mysql'