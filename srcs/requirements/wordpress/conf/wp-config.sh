#!/bin/bash

# Wait for MariaDB to be ready
while ! mariadb -h mariadb -u${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} -e "SELECT 1;" > /dev/null 2>&1; do
    echo "Waiting for MariaDB to be ready..."
    sleep 3
done

# Check if WordPress is already configured
if [ ! -f /var/www/html/wp-config.php ]; then
    # Create wp-config.php
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    
    # Update database settings
    sed -i "s/database_name_here/${MYSQL_DATABASE}/g" /var/www/html/wp-config.php
    sed -i "s/username_here/${MYSQL_USER}/g" /var/www/html/wp-config.php
    sed -i "s/password_here/${MYSQL_PASSWORD}/g" /var/www/html/wp-config.php
    sed -i "s/localhost/mariadb/g" /var/www/html/wp-config.php
    
    # Update security keys
    KEYS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
    KEYS="${KEYS//\//\\/}"
    sed -i "/define( 'AUTH_KEY'/,/define( 'NONCE_SALT'/d" /var/www/html/wp-config.php
    sed -i "/Put your unique phrase here/a\\${KEYS}" /var/www/html/wp-config.php
    
    # Install WordPress using WP-CLI
    wp core install --allow-root \
        --url="${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --path="/var/www/html" \
        --skip-email
    
    # Create a standard user
    wp user create --allow-root \
        "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=author \
        --path="/var/www/html"
    
    echo "WordPress has been successfully configured!"
fi

# Start PHP-FPM
php-fpm7.4 -F

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