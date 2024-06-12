#!/bin/bash

# Ensure the script stops on errors
set -e

STACK_NAME=$1
TEMPLATE_FILE=$2
PARAMETERS_FILE=$3
BUCKET_FOR_PACKAGING=$4

if [ -z "$STACK_NAME" ] || [ -z "$TEMPLATE_FILE" ] || [ -z "$PARAMETERS_FILE" ] || [ -z "$BUCKET_FOR_PACKAGING" ]; then
  echo "Usage: $0 <stack-name> <template-file> <parameters-file> <bucket-for-packaging>"
  exit 1
fi

# Temporary directory for packaging
PACKAGE_TEMP_DIR=$(mktemp -d)

# Find all subdirectories under the lambda directory
LAMBDA_DIRS=($(find lambda -maxdepth 1 -mindepth 1 -type d))

# Prepare the SAM template for dynamic updates
PACKAGED_TEMPLATE_FILE="packaged-template.yaml"
cp $TEMPLATE_FILE $PACKAGED_TEMPLATE_FILE

# Package each Lambda function
for LAMBDA_DIR in "${LAMBDA_DIRS[@]}"; do
  LAMBDA_NAME=$(basename "$LAMBDA_DIR")
  PACKAGE_FILE="$PACKAGE_TEMP_DIR/lambda_package.zip"

  echo "Packaging Lambda function in $LAMBDA_DIR"
  
  # Copy the lambda function code to the temporary directory
  cp -r "$LAMBDA_DIR/"* "$PACKAGE_TEMP_DIR/"
  
  # Install dependencies into the temporary directory
  if [ -f "$LAMBDA_DIR/requirements.txt" ]; then
    pip install -r "$LAMBDA_DIR/requirements.txt" -t "$PACKAGE_TEMP_DIR/"
  fi
  
  # Create a ZIP file for the Lambda function
  (cd "$PACKAGE_TEMP_DIR" && zip -r "$PACKAGE_FILE" .)
  
  # Upload the package to S3
  S3_URI="s3://$BUCKET_FOR_PACKAGING/$LAMBDA_NAME/lambda_package.zip"
  aws s3 cp "$PACKAGE_FILE" "$S3_URI"
  
  # Update the SAM template with the new S3 URL
  sed -i.bak "s|lambda/$LAMBDA_NAME/|$S3_URI|g" $PACKAGED_TEMPLATE_FILE

  # Clean up temporary files
  rm -rf "$PACKAGE_TEMP_DIR"/*
done

# Convert parameters file to SAM parameter overrides format
PARAMETER_OVERRIDES=$(jq -r '[ .[] | "ParameterKey=\(.ParameterKey),ParameterValue=\(.ParameterValue)" ] | join(" ")' "$PARAMETERS_FILE")

# Package the application using AWS SAM CLI
sam package \
  --template-file $PACKAGED_TEMPLATE_FILE \
  --output-template-file $PACKAGED_TEMPLATE_FILE \
  --s3-bucket $BUCKET_FOR_PACKAGING

# Deploy the packaged application
sam deploy \
  --template-file $PACKAGED_TEMPLATE_FILE \
  --stack-name $STACK_NAME \
  --parameter-overrides $PARAMETER_OVERRIDES \
  --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
  --no-fail-on-empty-changeset

# Clean up
rm -rf "$PACKAGE_TEMP_DIR"

echo "Deployment complete"


