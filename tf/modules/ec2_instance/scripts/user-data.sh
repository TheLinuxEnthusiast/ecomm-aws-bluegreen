#!/bin/bash

#export MARIADB_ROOT_PASSWORD="12345"
#sudo sh -c "echo export MARIADB_ROOT_PASSWORD='12345' >> /etc/profile.d/maria.sh"
cd /home/ec2-user/ecomm-lamp-app/
sudo docker-compose up --detach
