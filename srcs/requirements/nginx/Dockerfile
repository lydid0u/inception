FROM debian:bullseye

# Install NGINX and SSL tools
RUN apt-get update && apt-get install -y nginx openssl

# Copy configuration
COPY ./conf/nginx.conf /etc/nginx/sites-available/default
COPY ./conf/setup.sh /tmp/setup.sh

# Make script executable
RUN chmod +x /tmp/setup.sh

# Create directories for SSL certificates
RUN mkdir -p /etc/nginx/ssl

# Generate SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=localhost"

# Expose port 443
EXPOSE 443

# Run NGINX in foreground
ENTRYPOINT ["/tmp/setup.sh"]

# FROM debian:bullseye

# RUN apt-get update && apt-get install -y nginx openssl

# #on copie notre .conf et on le met dans limage nginx pour remplacer la config par defaut et mettre nos param
# COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

# # on genere le certificat SSL auto signé avec openSSL
# RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
#     -out /etc/ssl/lboudjel.42.fr.pem  \
#     -keyout /etc/ssl/lboudjel.42.fr.key \
#     -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=lboudjel/CN=lboudjel.42.fr"

# #on cree le dossier pour les sockets
# RUN mkdir -p /run/nginx

# EXPOSE 443

# CMD ["nginx", "-g", "daemon off;"]