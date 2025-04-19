FROM debian:buster

RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# Configure MariaDB to listen on all interfaces
RUN sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy initialization script
COPY ./conf/init_db.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/init_db.sh

# Create directory for MariaDB socket
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld

# Expose MariaDB port
EXPOSE 3306

# Start MariaDB server
CMD ["/docker-entrypoint-initdb.d/init_db.sh"]

# FROM debian:bullseye

# RUN apt-get update && apt-get install -y mariadb-server

# COPY ./conf/mariadb.sh /mariadb.sh

# RUN chmod +x mariadb.sh

# CMD ["/mariadb.sh"]