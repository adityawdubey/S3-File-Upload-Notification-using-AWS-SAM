# S3 File Upload Notification System using AWS Serverless Application Model 

This project is designed to provide a notification system for file uploads to an S3 bucket using AWS Lambda and other AWS services. When a file is uploaded to the specified S3 bucket, the system triggers a Lambda function which processes the file and sends notifications accordingly. 
To implement the project step by step using the AWS Management Console, you can follow this project design narrative in my blog website: [https://adityadubey.cloud/s3-file-upload-notification-system](https://adityadubey.cloud/s3-file-upload-notification-system).

## Table of Contents

- [Architecture](#architecture)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Setup and Deployment](#setup-and-deployment)
- [Usage](#usage)

## Architecture

The architecture consists of the following components:
- **S3 Bucket:** The designated storage location for uploaded files.
- **Lambda Function:** The heart of the system, automatically triggered by S3 events (file uploads), it processes the uploaded file and initiates notifications.
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
git clone https://github.com/your-username/s3-file-upload-notification-system.git
cd s3-file-upload-notification-system
```

### Configure AWS CLI
Ensure your AWS CLI is configured with the necessary permissions.

### Add dev parameters
Ensure the dev-parameters.json file is updated with your specific configurations and is added to .gitignore

<img width="556" alt="Screenshot 2024-06-13 at 6 56 08 PM" src="https://github.com/adityawdubey/S3-File-Upload-Notification-System-using-AWS-SAM/assets/88245579/ce2685db-b318-4db9-bac4-2b81d41e5922">


### Running the deployment Script

Run the deployment script located in scripts/deploy.sh

```
./scripts/deploy.sh <stack_name> templates/main.yaml parameters/dev-parameters.json <bucket-for-packaging>
```

This should correctly package your Lambda functions, update the SAM template, and deploy your stack with the specified parameters.

## Usage

Once deployed, any file uploaded to the specified S3 bucket will trigger the Lambda function. The Lambda function processes the file and sends a notification via SNS.




