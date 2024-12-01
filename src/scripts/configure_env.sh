#!/bin/bash -xe

# Set the application directory
APPDIR="/home/ec2-user/singlebox"

# Ensure the target directories exist
mkdir -p "$APPDIR/web" "$APPDIR/caddy"

# Set the prefix for the parameters
PREFIX="/singlebox"

# Function to fetch parameters and write them to a file
fetch_and_write_params() {
  local OUTPUT_FILE=$1
  shift
  local PARAMS=("$@")

  # Start with a clean file
  : > "$OUTPUT_FILE"

  echo "Fetching parameters for $OUTPUT_FILE from AWS SSM Parameter Store..."

  for PARAM in "${PARAMS[@]}"; do
    local FULL_NAME="$PREFIX/$PARAM"

    # Fetch the parameter value
    local VALUE
    VALUE=$(aws ssm get-parameter --name "$FULL_NAME" --with-decryption --query "Parameter.Value" --output text 2>/dev/null)
    local RETVAL=$?

    if [[ $RETVAL -ne 0 ]]; then
      echo "Error: Failed to fetch parameter: $FULL_NAME" >&2
      exit 1
    fi

    if [[ -z "$VALUE" ]]; then
      echo "Warning: Parameter $FULL_NAME has an empty value. Skipping..." >&2
      continue
    fi

    echo "$PARAM=$VALUE" >> "$OUTPUT_FILE"
  done

  echo "Environment variables written to $OUTPUT_FILE successfully."
}

# Define parameters for each service
WEB_PARAMS=("SECRET_KEY" "DEBUG" "ALLOWED_HOSTS" "DB_DATABASE" "DB_USER" "DB_PASSWORD" "DB_HOST" "DB_PORT")
CADDY_PARAMS=("SITE")

# Call the function for each service
fetch_and_write_params "$APPDIR/web/.env.prod" "${WEB_PARAMS[@]}"
fetch_and_write_params "$APPDIR/caddy/.env.prod" "${CADDY_PARAMS[@]}"
