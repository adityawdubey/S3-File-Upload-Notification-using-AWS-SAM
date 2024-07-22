import json
import boto3
import os

s3_client = boto3.client('s3')
sns_client = boto3.client('sns')
sqs_client = boto3.client('sqs')

def lambda_handler(event, context):
    sns_topic_arn = os.environ['SNS_TOPIC_ARN']
    sqs_queue_url = os.environ['SQS_QUEUE_URL']

    for record in event['Records']:
        print(event)
        s3_bucket = record['s3']['bucket']['name']
        s3_key = record['s3']['object']['key']

        metadata = {
            'bucket': s3_bucket,
            'key': s3_key,
            'timestamp': record['eventTime']
        }

        sqs_response = sqs_client.send_message(
            QueueUrl=sqs_queue_url,
            MessageBody=json.dumps(metadata)
        )

        notification_message = f"New file uploaded to S3 bucket '{s3_bucket}' with key '{s3_key}'"

        sns_response = sns_client.publish(
            TopicArn=sns_topic_arn,
            Message=notification_message,
            Subject="File Upload Notification"
        )

    return {
        'statusCode': 200,
        'body': json.dumps('Processing complete')
    }
