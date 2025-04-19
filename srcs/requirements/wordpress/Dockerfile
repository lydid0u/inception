FROM debian:buster

RUN apt-get update && apt-get install -y \
    php7.3 \
    php7.3-fpm \
    php7.3-mysql \
    php7.3-gd \
    php7.3-curl \
    php7.3-xml \
    php7.3-mbstring \
    php7.3-zip \
    wget \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Configure PHP-FPM to listen on network
RUN mkdir -p /run/php && \
    sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf

# Copy WordPress setup script
COPY ./conf/wp_setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wp_setup.sh

# Set working directory
WORKDIR /var/www/html

# Expose port 9000
EXPOSE 9000

# Start PHP-FPM and run the WordPress setup script
CMD ["/usr/local/bin/wp_setup.sh"]

# FROM debian:bullseye

# RUN apt-get update && apt-get upgrade -y

# RUN apt-get install -y php7.4 php-fpm php-mysql mariadb-client curl

# COPY /conf/wordpress.sh /

# RUN  chmod +x wordpress.sh

# ENTRYPOINT ["./wordpress.sh"]