FROM ubuntu:20.04

LABEL version="1.0"
LABEL description="Simple PHP based ecommerce application container running on port 80"
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

# Change configuration for /etc/apache2/apache2.conf
RUN sed -i "/^<Directory \/var\/www\/>/a\\\tOrder allow,deny" /etc/apache2/apache2.conf && \
	sed -i "/^<Directory \/var\/www\/>/a\\\tallow from all" /etc/apache2/apache2.conf && \
	sed -i "/^<Directory \/var\/www\/>/a\\\tDirectoryIndex index.php index.html" /etc/apache2/apache2.conf && \
	sed -i "s/Options Indexes FollowSymLinks$/& MultiViews/" /etc/apache2/apache2.conf && \
	sed -i "175s/AllowOverride None/AllowOverride All/" /etc/apache2/apache2.conf


COPY . /var/www/html/


EXPOSE 80

RUN /sbin/service apache2 restart

CMD [ "apache2ctl", "-D", "FOREGROUND"]
