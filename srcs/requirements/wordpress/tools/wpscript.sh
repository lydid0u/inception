#!/bin/sh

# Vérifie si le fichier wp-config.php existe déjà dans le répertoire courant
if [ -f ./wp-config.php ]
then
    echo "Wordpress already installed, skipping download and configuration."
else
	# Télécharge WordPress en utilisant WP-CLI et crée le fichier de configuration wp-config.php
    wp core download --allow-root \
    && wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=$MYSQL_HOSTNAME --allow-root \
    && wp core install --url=$DOMAIN_NAME --title=$WP_TITLE --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASSWD --admin_email=$WP_ADMIN_MAIL --allow-root \
    && wp user create $WP_USER $WP_USER_MAIL --role=author --user_pass=$WP_USER_PASSWD --porcelain --allow-root
fi

# Lance le serveur PHP-FPM pour traiter les scripts PHP de WordPress
/usr/sbin/php-fpm7.3 -F -R