#!/bin/bash

# Check if the database directory is empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
    # Initialize MySQL data directory
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Start MySQL service temporarily
    mysqld_safe --datadir=/var/lib/mysql &
    
    # Wait for MySQL server to start
    sleep 5
    
    # Create database and user
    mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    # Stop the temporary MySQL service
    pkill mysqld
    sleep 5
    
    echo "Database and user created successfully!"
fi

# Start MariaDB server
mysqld_safe --datadir=/var/lib/mysql

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