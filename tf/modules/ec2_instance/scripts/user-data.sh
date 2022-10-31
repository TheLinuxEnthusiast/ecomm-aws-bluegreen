#!/bin/bash
export MARIADB_ROOT_PASSWORD="12345"
cd /home/ec2-user/ecomm-lamp-app/
docker-compose up --detach
