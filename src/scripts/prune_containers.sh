#!/bin/bash -xe

APPDIR=/home/ec2-user/singlebox
cd $APPDIR
docker system prune --force
