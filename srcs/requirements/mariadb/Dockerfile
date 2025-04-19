FROM debian:bullseye

# Install MariaDB server
RUN apt-get update && apt-get install -y mariadb-server

# Configure MariaDB to allow connections from any IP
RUN sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy initialization script
COPY ./conf/init.sh /tmp/init.sh
RUN chmod +x /tmp/init.sh

# Expose port 3306
EXPOSE 3306

# Run MariaDB server
ENTRYPOINT ["/tmp/init.sh"]

# FROM debian:bullseye

# RUN apt-get update && apt-get install -y mariadb-server

# COPY ./conf/mariadb.sh /mariadb.sh

# RUN chmod +x mariadb.sh

# CMD ["/mariadb.sh"]