#!/bin/bash -xe

# Set the application directory
APPDIR="/home/ec2-user/singlebox"
OUTPUT_FILE="$APPDIR/web/.env.prod"

# Ensure the target directory exists
mkdir -p "$APPDIR/web"

# Set the prefix for the parameters
PREFIX="/singlebox"

# Define the parameters to fetch
PARAMS=(
  "SECRET_KEY"
  "DEBUG"
  "ALLOWED_HOSTS"
  "DB_DATABASE"
  "DB_USER"
  "DB_PASSWORD"
  "DB_HOST"
  "DB_PORT"
)

# Start with a clean file
true > "$OUTPUT_FILE"

echo "Fetching parameters from AWS SSM Parameter Store..."

# Loop through each parameter, fetch its value, and append to the file
for PARAM in "${PARAMS[@]}"; do
  FULL_NAME="$PREFIX/$PARAM"

  # Fetch the parameter value
  aws ssm get-parameter --name "$FULL_NAME" --with-decryption --query "Parameter.Value" --output text
  VALUE=$(aws ssm get-parameter --name "$FULL_NAME" --with-decryption --query "Parameter.Value" --output text)

  if [[ $? -ne 0 ]]; then
    echo "Failed to fetch parameter: $FULL_NAME"
    exit 1
  fi

  # Append the parameter to the .env.prod file
  echo "$PARAM=$VALUE" >> "$OUTPUT_FILE"
done

echo "Environment variables written to $OUTPUT_FILE successfully."
