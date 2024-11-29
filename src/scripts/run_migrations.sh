#!/bin/bash -xe

APPDIR=/home/ec2-user/singlebox
cd $APPDIR
docker-compose exec web python manage.py migrate
