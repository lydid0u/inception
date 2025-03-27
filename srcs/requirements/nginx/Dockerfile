FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl

#on copie notre .conf et on le met dans limage nginx pour remplacer la config par defaut et mettre nos param
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

# on genere le certificat SSL auto signé avec openSSL
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
    -out /etc/ssl/lboudjel.42.fr.pem  \
    -keyout /etc/ssl/lboudjel.42.fr.key \
    -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=lboudjel/CN=lboudjel.42.fr"

#on cree le dossier pour les sockets
RUN mkdir -p /run/nginx

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]