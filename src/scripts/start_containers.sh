#!/bin/bash -xe

APPDIR=/home/ec2-user/singlebox
cd $APPDIR
docker-compose up --build -d
