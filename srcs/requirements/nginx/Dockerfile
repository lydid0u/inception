# Utilisation de l'image de base Debian Buster
FROM debian:buster

# Installation de Nginx et OpenSSL
RUN apt-get update && apt-get install -y nginx openssl

# Copie du fichier de configuration nginx.conf dans le conteneur
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

# Génération du certificat SSL auto-signé avec OpenSSL
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
    -out /etc/ssl/lboudjel.42.fr.pem  \
    -keyout /etc/ssl/lboudjel.42.fr.key \
    -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=lboudjel/CN=lboudjel.42.fr"

# Création du répertoire pour les fichiers de socket de Nginx
RUN mkdir -p /run/nginx

# Exposition du port 443 pour les connexions HTTPS
EXPOSE 443

# Commande par défaut pour démarrer Nginx en mode non-daemon
CMD ["nginx", "-g", "daemon off;"]