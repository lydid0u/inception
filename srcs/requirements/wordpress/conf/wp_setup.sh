#!/bin/bash

# Wait for MariaDB to be ready
while ! mariadb -h mariadb -u${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SELECT 1;" ${MYSQL_DATABASE} 2>/dev/null; do
    echo "Waiting for MariaDB to be ready..."
    sleep 5
done

# Check if WordPress is already installed
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Setting up WordPress..."
    
    # Download WordPress
    curl -O https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    cp -r wordpress/* /var/www/html/
    rm -rf wordpress latest.tar.gz
    
    # Create wp-config.php
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    sed -i "s/database_name_here/${MYSQL_DATABASE}/g" /var/www/html/wp-config.php
    sed -i "s/username_here/${MYSQL_USER}/g" /var/www/html/wp-config.php
    sed -i "s/password_here/${MYSQL_PASSWORD}/g" /var/www/html/wp-config.php
    sed -i "s/localhost/mariadb/g" /var/www/html/wp-config.php
    
    # Generate security keys
    for key in AUTH_KEY SECURE_AUTH_KEY LOGGED_IN_KEY NONCE_KEY AUTH_SALT SECURE_AUTH_SALT LOGGED_IN_SALT NONCE_SALT; do
        sed -i "s/define( '$key', '.*' );/define( '$key', '$(openssl rand -base64 64 | tr -d '\n\r' | sed "s/'//g" | cut -c1-64)' );/g" /var/www/html/wp-config.php
    done
    
    # Download WP-CLI
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
    
    # Install WordPress
    cd /var/www/html
    wp core install --url=${DOMAIN_NAME} --title=${WP_TITLE} --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL} --allow-root
    
    # Create additional user
    wp user create ${WP_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSWORD} --role=author --allow-root
    
    echo "WordPress setup completed."
fi

# Ensure correct ownership
chown -R www-data:www-data /var/www/html

# Start PHP-FPM
echo "Starting PHP-FPM..."
php-fpm7.3 -F

# #!/bin/bash

# #on installe wp cote client
# curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# chmod +x wp-cli.phar
# mv wp-cli.phar /usr/local/bin/wp

# #on configure le dossier de travail
# cd /var/www/wordpress
# chmod -R 755 /var/www/wordpress/
# chown -R www-data:www-data /var/www/wordpress

# if [ ! -f ./wp-config.php ]; then
#     echo "***Installing WordPress***"
#     wp core download --allow-root
#     wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb:3306 --allow-root
#     wp core install --url=$DOMAIN_NAME --title=$WP_TITLE --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASSWD --admin_email=$WP_ADMIN_MAIL --allow-root
#     wp user create $WP_USER $WP_USER_MAIL --role=author --user_pass=$WP_USER_PASSWD --allow-root
# fi

# #installation de php pour communiquer avec nginx sur le port 9000
# sed -i 's/listen = .*/listen = 0.0.0.0:9000/' /etc/php/7.*/fpm/pool.d/www.conf
# mkdir -p /run/php

# # Démarrage de PHP-FPM en mode premier plan
# /usr/sbin/php-fpm7.* -F