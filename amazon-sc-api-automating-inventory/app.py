import boto3
from amazon_sp_api import Reports
import logging
import json
from botocore.exceptions import NoCredentialsError, PartialCredentialsError

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def fetch_amazon_inventory(sp_api_credentials, marketplace_id):
    try:
        logging.info("Fetching inventory data from SP-API...")
        report = Reports(credentials=sp_api_credentials)
        report_response = report.create_report(
            report_type='GET_MERCHANT_LISTINGS_ALL_DATA',
            marketplace_ids=[marketplace_id]
        )
        logging.info("Successfully fetched inventory data.")
        return report_response
    except Exception as e:
        logging.error(f"Error fetching inventory data: {e}")
        return None

def upload_to_s3(bucket_name, key, data, aws_credentials):
    try:
        logging.info(f"Uploading data to S3 bucket: {bucket_name}, key: {key}...")
        s3 = boto3.client(
            's3',
            aws_access_key_id=aws_credentials['aws_access_key'],
            aws_secret_access_key=aws_credentials['aws_secret_key']
        )
        s3.put_object(Bucket=bucket_name, Key=key, Body=data)
        logging.info("Data successfully uploaded to S3.")
    except NoCredentialsError:
        logging.error("AWS credentials not found!")
    except PartialCredentialsError:
        logging.error("Incomplete AWS credentials!")
    except Exception as e:
        logging.error(f"Error uploading to S3: {e}")

def main():
    # SP-API credentials
    sp_api_credentials = {
        'refresh_token': 'your_refresh_token',
        'lwa_app_id': 'your_client_id',
        'lwa_client_secret': 'your_client_secret',
        'role_arn': 'your_role_arn'  # Required if using IAM roles
    }
    
    aws_credentials = {
        'aws_access_key': 'your_aws_access_key',
        'aws_secret_key': 'your_aws_secret_key'
    }
    
    # Define marketplace and S3 parameters
    marketplace_id = "ATVPDKIKX0DER"  # Replace with your marketplace ID
    bucket_name = "your-s3-bucket-name"
    key = "inventory/reports/inventory_report.json"
    
    # Fetch inventory data
    inventory_data = fetch_amazon_inventory(sp_api_credentials, marketplace_id)
    if inventory_data:
        # Convert data to JSON string for S3 upload
        inventory_json = json.dumps(inventory_data, indent=2)
        # Upload to S3
        upload_to_s3(bucket_name, key, inventory_json, aws_credentials)
    else:
        logging.error("No inventory data fetched. Exiting script.")

if __name__ == "__main__":
    main()
