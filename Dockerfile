FROM ubuntu:20.04

LABEL version="1.0"
LABEL description="Simple PHP based ecommerce application container"
LABEL author="Darren Foley"
LABEL email="darrenfoley015@gmail.com"

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
#ENV DB_HOSTNAME $DB_HOST

RUN echo "tzdata tzdata/Areas select Europe" > /tmp/preseed.txt; \
    echo "tzdata tzdata/Zones/Europe select Dublin" >> /tmp/preseed.txt; \
    debconf-set-selections /tmp/preseed.txt && \
    apt update -y && \
    apt install -y tzdata

RUN apt install -y apache2 php php-mysql

RUN apt clean

#RUN echo "DirectoryIndex index.php index.html" >> /etc/apache2/apache2.conf
RUN sed -i "/^<Directory \/var\/www\/>/a\\\tOrder allow,deny" /etc/apache2/apache2.conf && \
	sed -i "/^<Directory \/var\/www\/>/a\\\tallow from all" /etc/apache2/apache2.conf && \
	sed -i "/^<Directory \/var\/www\/>/a\\\tDirectoryIndex index.php index.html" /etc/apache2/apache2.conf && \
	sed -i "s/Options Indexes FollowSymLinks$/& MultiViews/" /etc/apache2/apache2.conf

COPY . /var/www/html/

#RUN sed -i "s/172.20.1.101/${DB_HOSTNAME}/g" '/var/www/html/index.php'

EXPOSE 80

RUN /sbin/service apache2 restart

CMD [ "apache2ctl", "-D", "FOREGROUND"]
