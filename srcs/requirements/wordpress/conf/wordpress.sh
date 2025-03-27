#!/bin/bash

#on installe wp cote client
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

#on configure le dossier de travail
cd /var/www/wordpress
chmod -R 755 /var/www/wordpress/
chown -R www-data:www-data /var/www/wordpress

if [ ! -f ./wp-config.php ]; then
    echo "***Installing WordPress***"
    wp core download --allow-root
    wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb:3306 --allow-root
    wp core install --url=$DOMAIN_NAME --title=$WP_TITLE --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASSWD --admin_email=$WP_ADMIN_MAIL --allow-root
    wp user create $WP_USER $WP_USER_MAIL --role=author --user_pass=$WP_USER_PASSWD --allow-root
fi

#installation de php pour communiquer avec nginx sur le port 9000
sed -i 's/listen = .*/listen = 0.0.0.0:9000/' /etc/php/7.*/fpm/pool.d/www.conf
mkdir -p /run/php

# Démarrage de PHP-FPM en mode premier plan
/usr/sbin/php-fpm7.* -F