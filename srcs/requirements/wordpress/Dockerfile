# Utilisation de l'image de base Debian Buster
FROM debian:buster

# Mise à jour des dépôts de paquets et installation des packages nécessaires
RUN apt-get update -y && apt-get install -y \
    curl \
    php7.3 \
    php7.3-fpm \
    php7.3-mysql \
    php7.3-common \
    mariadb-client \
    sendmail \
    wget

# Téléchargement et installation de WP-CLI (WordPress Command Line Interface)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
        && chmod +x wp-cli.phar \
        && mv wp-cli.phar /usr/local/bin/wp

# Création du répertoire pour les fichiers WordPress et attribution des permissions appropriées
RUN mkdir -p /var/www/inception \
        && chown -R www-data:www-data /var/www/inception
RUN chmod -R 755 /var/www/inception

# Copie du fichier de configuration www.conf pour PHP-FPM
COPY conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf

# Copie du script wpscript.sh dans le répertoire /var/www
COPY tools/wpscript.sh /var/www/wpscript.sh
RUN chmod +x /var/www/wpscript.sh

# Création du répertoire pour les fichiers de socket PHP
RUN mkdir -p /run/php

# Définition du répertoire de travail
WORKDIR /var/www/inception

# Exposition du port 9000 utilisé par PHP-FPM
EXPOSE 9000

# Commande par défaut pour démarrer le script wpscript.sh lors du lancement du conteneur
CMD ["/var/www/wpscript.sh"]