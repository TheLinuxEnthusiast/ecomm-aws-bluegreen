FROM mariadb:jammy

ENV MYSQL_USER=ecomuser \
    MYSQL_PASSWORD=ecompassword \
    MYSQL_DATABASE=ecomdb \
    MYSQL_ROOT_PASSWORD=12345

COPY ./init_script.sql /docker-entrypoint-initdb.d

EXPOSE 3306
