FROM debian:bullseye

# Install PHP and required extensions
RUN apt-get update && apt-get install -y \
    php7.3-fpm \
    php7.3-mysql \
    php7.3-curl \
    php7.3-gd \
    php7.3-intl \
    php7.3-mbstring \
    php7.3-soap \
    php7.3-xml \
    php7.3-xmlrpc \
    php7.3-zip \
    wget \
    curl \
    mariadb-client

# Configure PHP-FPM to listen on the network
RUN sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf

# Create directory for PHP-FPM socket and PID file
RUN mkdir -p /run/php

# Download WordPress
WORKDIR /var/www/html
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    mv wordpress/* . && \
    rm -rf wordpress latest.tar.gz && \
    chown -R www-data:www-data /var/www/html

# Copy configuration script
COPY ./conf/wp-config.sh /tmp/wp-config.sh
RUN chmod +x /tmp/wp-config.sh

# Expose port 9000
EXPOSE 9000

# Start PHP-FPM server
ENTRYPOINT ["/tmp/wp-config.sh"]

# FROM debian:bullseye

# RUN apt-get update && apt-get upgrade -y

# RUN apt-get install -y php7.4 php-fpm php-mysql mariadb-client curl

# COPY /conf/wordpress.sh /

# RUN  chmod +x wordpress.sh

# ENTRYPOINT ["./wordpress.sh"]