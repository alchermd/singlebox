#!/bin/bash -xe

# Define the application directory
APPDIR="/home/ec2-user/singlebox"

# Ensure the directory exists before proceeding
if [[ -d "$APPDIR" ]]; then
  cd "$APPDIR"
else
  echo "Error: Directory $APPDIR does not exist."
  exit 1
fi

# Prune unused Docker resources
docker system prune --force
