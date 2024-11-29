#!/bin/bash -xe

## CodeDeploy Agent Bootstrap Script for Amazon Linux ##

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

function installdep(){
  yum -y update
  yum install -y aws-cli ruby jq
}

function execute(){
  cd /tmp/
  wget https://aws-codedeploy-${REGION}.s3.amazonaws.com/latest/install
  chmod +x ./install

  if ! ./install auto; then
    echo "Installation script failed, please investigate"
    rm -f /tmp/install
    exit 1
  fi

  echo "Installing Docker"
  yum -y install docker
  systemctl enable docker
  systemctl start docker
  usermod -a -G docker ec2-user
  docker version

  echo "Installing Docker Compose"
  curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose

  echo "Installation completed"
  exit 0
}

installdep
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
REGION=$(curl -H "X-aws-ec2-metadata-token: $TOKEN"  -v http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r ".region")
execute
