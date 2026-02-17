"""
Upload NYC FHV (For-Hire Vehicle) data for 2019 to GCS bucket
Data source: https://github.com/DataTalksClub/nyc-tlc-data/releases/tag/fhv
"""

import requests
import gzip
from google.cloud import storage
from pathlib import Path
import logging

# Setup logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Configuration
GCP_PROJECT_ID = "dtc-de-course-486009"
GCS_BUCKET_NAME = "dtc-decourse-dbt-nytaxi"
YEARS = [2019]  # FHV data only for 2019
MONTHS = range(1, 13)  # 1 to 12

# Local directory for temporary files
LOCAL_DATA_DIR = Path("data")
LOCAL_DATA_DIR.mkdir(exist_ok=True)


def download_and_decompress_file(year: int, month: int) -> Path:
    """
    Download a FHV data file from GitHub releases and decompress it.

    Args:
        year: Year (2019)
        month: Month (1-12)

    Returns:
        Path to the decompressed CSV file
    """
    month_str = f"{month:02d}"
    filename = f"fhv_tripdata_{year}-{month_str}"
    url = f"https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv/{filename}.csv.gz"

    local_gz_path = LOCAL_DATA_DIR / f"{filename}.csv.gz"
    local_csv_path = LOCAL_DATA_DIR / f"{filename}.csv"

    # Skip if already downloaded
    if local_csv_path.exists():
        logger.info(f"File {filename}.csv already exists, skipping download")
        return local_csv_path

    logger.info(f"Downloading {url}")
    try:
        response = requests.get(url, stream=True)
        response.raise_for_status()

        # Save compressed file
        with open(local_gz_path, 'wb') as f:
            for chunk in response.iter_content(chunk_size=8192):
                f.write(chunk)

        # Decompress
        logger.info(f"Decompressing {filename}.csv.gz")
        with gzip.open(local_gz_path, 'rb') as f_in:
            with open(local_csv_path, 'wb') as f_out:
                f_out.write(f_in.read())

        # Remove compressed file to save space
        local_gz_path.unlink()

        logger.info(f"Successfully downloaded and decompressed {filename}.csv")
        return local_csv_path

    except requests.exceptions.RequestException as e:
        logger.error(f"Failed to download {url}: {e}")
        return None


def upload_to_gcs(local_file: Path, bucket_name: str) -> str:
    """
    Upload a file to Google Cloud Storage.

    Args:
        local_file: Path to local file
        bucket_name: GCS bucket name

    Returns:
        GCS URI (gs://bucket/file)
    """
    storage_client = storage.Client(project=GCP_PROJECT_ID)
    bucket = storage_client.bucket(bucket_name)
    blob_name = local_file.name
    blob = bucket.blob(blob_name)

    # Check if file already exists in GCS
    if blob.exists():
        logger.info(f"File {blob_name} already exists in GCS, skipping upload")
        return f"gs://{bucket_name}/{blob_name}"

    logger.info(f"Uploading {local_file.name} to gs://{bucket_name}/{blob_name}")
    blob.upload_from_filename(str(local_file))

    gcs_uri = f"gs://{bucket_name}/{blob_name}"
    logger.info(f"Successfully uploaded to {gcs_uri}")
    return gcs_uri


def check_gcs_bucket_exists(bucket_name: str) -> bool:
    """Check if GCS bucket exists."""
    try:
        storage_client = storage.Client(project=GCP_PROJECT_ID)
        bucket = storage_client.bucket(bucket_name)
        bucket.reload()
        logger.info(f"Bucket gs://{bucket_name} exists and is accessible")
        return True
    except Exception as e:
        logger.error(f"Bucket gs://{bucket_name} does not exist or is not accessible: {e}")
        return False


def main():
    """Main function to orchestrate the FHV data upload process."""

    logger.info("="*60)
    logger.info("NYC FHV (For-Hire Vehicle) Data Upload to GCS")
    logger.info("="*60)

    # Check if bucket exists
    logger.info("\nChecking GCS bucket...")
    if not check_gcs_bucket_exists(GCS_BUCKET_NAME):
        logger.error(f"\nPlease create the bucket first using:")
        logger.error(f"  gsutil mb -p {GCP_PROJECT_ID} -l US gs://{GCS_BUCKET_NAME}")
        return

    # Process all combinations of year and month
    total_files = len(YEARS) * len(MONTHS)
    processed = 0
    successful = 0
    failed = 0

    logger.info(f"\nStarting upload of {total_files} FHV files...")
    logger.info(f"Years: {', '.join(map(str, YEARS))}")
    logger.info(f"Months: 01-12")

    for year in YEARS:
        for month in MONTHS:
            processed += 1
            logger.info(f"\n{'='*60}")
            logger.info(f"[{processed}/{total_files}] Processing FHV {year}-{month:02d}")
            logger.info(f"{'='*60}")

            # Download and decompress
            local_file = download_and_decompress_file(year, month)
            if not local_file:
                logger.warning(f"Skipping FHV {year}-{month:02d} due to download failure")
                failed += 1
                continue

            # Upload to GCS
            try:
                gcs_uri = upload_to_gcs(local_file, GCS_BUCKET_NAME)
                successful += 1
            except Exception as e:
                logger.error(f"Failed to upload to GCS: {e}")
                failed += 1
                continue

            # Optional: Clean up local file to save disk space
            # Uncomment the line below to delete local files after upload
            # local_file.unlink()

    # Summary
    logger.info("\n" + "="*60)
    logger.info("Upload Summary")
    logger.info("="*60)
    logger.info(f"Total files processed: {processed}/{total_files}")
    logger.info(f"Successful uploads:    {successful}")
    logger.info(f"Failed uploads:        {failed}")
    logger.info(f"\nAll files uploaded to: gs://{GCS_BUCKET_NAME}/")
    logger.info("="*60)

    if successful > 0:
        logger.info("\nNext steps:")
        logger.info("1. Create BigQuery external table for FHV data")
        logger.info("2. Run dbt to build stg_fhv_tripdata model")
        logger.info("3. Query the data in BigQuery")


if __name__ == "__main__":
    main()