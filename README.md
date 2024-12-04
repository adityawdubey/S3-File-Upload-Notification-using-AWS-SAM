# S3 File Upload Notification System using AWS Serverless Application Model 

This project is designed to provide a notification system for file uploads to an S3 bucket using AWS Lambda and other AWS services. When a file is uploaded to the specified S3 bucket, the system triggers a Lambda function which processes the file and sends notifications accordingly. 
To implement the project step by step using the AWS Management Console, you can follow this project design narrative in my blog website: [https://adityadubey.cloud/s3-file-upload-notification-system](https://adityadubey.tech/s3-file-upload-notification-system).

## Table of Contents

- [Architecture](#architecture)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Setup and Deployment](#setup-and-deployment)
- [Usage](#usage)

## Architecture

The architecture consists of the following components:
- **S3 Bucket:** The designated storage location for uploaded files.
- **Lambda Function:** It allows snippets of code to execute in response to triggers caused by activity from other AWS resources such as an AWS CloudWatch alarm, changes in a NoSQL table as DynamoDB, an upload event in an S3 bucket, etc.
- **Amazon SNS (Simple Notification Service):** Used to send notifications to subscribers via various channels (email, SMS, etc.).
- **Amazon CloudWatch:** Provides logging and monitoring of the Lambda function's execution, ensuring observability and troubleshooting capabilities.

![S3 Notification (4)](https://github.com/adityawdubey/S3-File-Upload-Notification-System-using-AWS-SAM/assets/88245579/04732c67-86b9-43e6-8e11-4bf1cf5bd4cb)

## Features

- **Automated Notifications:** Instantly trigger notifications upon file uploads to the S3 bucket.
- **Flexible Processing:** The Lambda function can be customized to perform file validation, data extraction, or other processing actions before sending notifications.
- **Multi-Channel Notifications:** Leverage SNS to deliver notifications via email, SMS, or other supported protocols.
- **Detailed Logging:** CloudWatch Logs capture function execution details for debugging and analysis.

## Prerequisites

- **AWS Account:** An active AWS account is required to utilize the services.
- **AWS CLI:** Installed and configured on your local machine to interact with AWS resources.
- **AWS SAM CLI:** Streamlines the deployment of serverless applications on AWS.
- **Python 3.8+:** The Lambda function is written in Python.
- **jq:** A command-line JSON processor (optional, for working with JSON output).

## Setup and Deployment

### Clone the Repository

```bash
git clone https://github.com/adityawdubey/S3-File-Upload-Notification-using-AWS-SAM.git
cd S3-File-Upload-Notification-using-AWS-SAM
```

### Configure AWS CLI
Ensure your AWS CLI is configured with the necessary permissions.

### Add dev parameters
Ensure the dev-parameters.json file is updated with your specific configurations and is added to .gitignore

<img width="556" alt="Screenshot 2024-06-13 at 6 56 08 PM" src="https://github.com/adityawdubey/S3-File-Upload-Notification-System-using-AWS-SAM/assets/88245579/ce2685db-b318-4db9-bac4-2b81d41e5922">


### Running the deployment Script

Make the script Executable

```
chmod +x ././scripts/deploy.sh
```

Run the deployment script located in scripts/deploy.sh

```
./scripts/deploy.sh <stack_name> templates/main.yaml parameters/dev-parameters.json <bucket-for-packaging>
```

This should correctly package your Lambda functions, update the SAM template, and deploy your stack with the specified parameters.

## Overcomming Challenges

### Specify SAM template parameters using parameters.json

One challenge faced during the deployment process was that the AWS SAM CLI does not accept a JSON file for parameters like CloudFormation does. To work around this limitation, jq is used in the deployment script to convert the parameters from a parameters.json file into a format that the AWS SAM CLI can understand.

The SAM CLI requires parameters to be passed as a string in the format ParameterKey=key,ParameterValue=value. Using jq, we can transform the JSON structure of the parameters file into this required format.

Here’s how jq is utilized in the deployment script:
```
# Convert parameters file to SAM parameter overrides format
PARAMETER_OVERRIDES=$(jq -r '[ .[] | "ParameterKey=\(.ParameterKey),ParameterValue=\(.ParameterValue)" ] | join(" ")' "$PARAMETERS_FILE")
```
This command reads the JSON file specified by PARAMETERS_FILE and processes each element to create a string in the required format. The final result is a single string with all parameters properly formatted for the SAM CLI, allowing seamless deployment.


## Usage

Once deployed, any file uploaded to the specified S3 bucket will trigger the Lambda function. The Lambda function processes the file and sends a notification via SNS.

## References

- https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/what-is-sam.html
- https://github.com/aws/aws-sam-cli/issues/2054
- https://docs.aws.amazon.com/lambda/latest/dg/foundation-iac.html
- https://docs.aws.amazon.com/prescriptive-guidance/latest/choose-iac-tool/aws-sam.html



