FROM ubuntu:20.04

LABEL version="1.0"
LABEL description="Simple PHP based ecommerce application container running on port 80 & 443"
LABEL author="Darren Foley"
LABEL email="darrenfoley015@gmail.com"

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# Resolve timezone information for apache2
RUN echo "tzdata tzdata/Areas select Europe" > /tmp/preseed.txt; \
    echo "tzdata tzdata/Zones/Europe select Dublin" >> /tmp/preseed.txt; \
    debconf-set-selections /tmp/preseed.txt && \
    apt update -y && \
    apt install -y tzdata

RUN apt install -y apache2 php php-mysql

RUN apt clean

RUN a2enmod ssl && a2enmod rewrite

# Create openssl cert
RUN mkdir -p /etc/apache2/certificate && \
	openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 \
	-nodes -out /etc/apache2/certificate/apache-certificate.crt \
	-keyout /etc/apache2/certificate/apache.key \
	-subj "/C=IE/ST=Dublin/L=Dublin/O=Custom/OU=DevOPS/CN=172.20.0.2"


# Edit the /etc/apache2/sites-enabled/000-default.conf file
COPY ./000-default.conf /etc/apache2/sites-enabled/000-default.conf

# Change configuration for /etc/apache2/apache2.conf
RUN sed -i "/^<Directory \/var\/www\/>/a\\\tOrder allow,deny" /etc/apache2/apache2.conf && \
	sed -i "/^<Directory \/var\/www\/>/a\\\tallow from all" /etc/apache2/apache2.conf && \
	sed -i "/^<Directory \/var\/www\/>/a\\\tDirectoryIndex index.php index.html" /etc/apache2/apache2.conf && \
	sed -i "s/Options Indexes FollowSymLinks$/& MultiViews/" /etc/apache2/apache2.conf && \
	sed -i "175s/AllowOverride None/AllowOverride All/" /etc/apache2/apache2.conf


COPY . /var/www/html/


EXPOSE 80
EXPOSE 443

RUN /sbin/service apache2 restart

CMD [ "apache2ctl", "-D", "FOREGROUND"]
