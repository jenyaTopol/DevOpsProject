from amazon_sp_api.apis.Reports import Reports
from amazon_sp_api.apis.Sellers import Sellers
import boto3
import json
import logging
from botocore.exceptions import NoCredentialsError, PartialCredentialsError

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def check_seller_status(credentials):
    """
    Check seller's account status to ensure SP-API connection is working.
    """
    try:
        sellers = Sellers(credentials=credentials)
        seller_status = sellers.get_marketplace_participations()
        logging.info(f"Seller Status: {seller_status}")
    except Exception as e:
        logging.error(f"Failed to fetch seller status: {e}")

def fetch_amazon_inventory(credentials, marketplace_ids):
    """
    Fetch inventory data from SP-API.
    """
    try:
        logging.info("Fetching inventory data from SP-API...")
        reports = Reports(credentials=credentials)
        
        # Create the report
        report_response = reports.create_report(
            reportType="GET_MERCHANT_LISTINGS_ALL_DATA",
            marketplaceIds=marketplace_ids
        )
        report_id = report_response['reportId']
        logging.info(f"Report created with ID: {report_id}")

        # Retrieve the report
        report_document = reports.get_report_document(report_id=report_id)
        report_data = reports.download(report_document)
        logging.info("Successfully fetched inventory data.")
        return report_data
    except Exception as e:
        logging.error(f"Error fetching inventory data: {e}")
        return None

def upload_to_s3(bucket_name, key, data, aws_credentials):
    """
    Upload data to an S3 bucket.
    """
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
        'aws_access_key': 'your_aws_access_key',
        'aws_secret_key': 'your_aws_secret_key',
        'role_arn': 'your_role_arn'
    }
    
    aws_credentials = {
        'aws_access_key': 'your_aws_access_key',
        'aws_secret_key': 'your_aws_secret_key'
    }

    # Define marketplace and S3 parameters
    marketplace_ids = ["ATVPDKIKX0DER"]  # Replace with your marketplace ID(s)
    bucket_name = "your-s3-bucket-name"
    key = "inventory/reports/inventory_report.json"

    # Check seller status
    check_seller_status(sp_api_credentials)

    # Fetch inventory data
    inventory_data = fetch_amazon_inventory(sp_api_credentials, marketplace_ids)
    if inventory_data:
        # Convert data to JSON string for S3 upload
        inventory_json = json.dumps(inventory_data, indent=2)
        # Upload to S3
        upload_to_s3(bucket_name, key, inventory_json, aws_credentials)
    else:
        logging.error("No inventory data fetched. Exiting script.")

if __name__ == "__main__":
    main()
