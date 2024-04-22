# Description: This script bundles the HIPV RGC pipeline files into a tarball and uploads it to a Google Cloud Storage location.
# Usage: ./deploy.sh --location your_gcs_location

# Check if location is provided
if [[ $# -lt 2 || "$1" != "--location" ]]; then
    echo "Error: --location parameter is required."
    echo "Usage example: ./deploy.sh --location your_gcs_location"
    exit 1
fi

GSUTIL_URI="$2"
TAR_FILE="test.tar.gz"

TEMP_DIR=$(mktemp -d)

cp main.nf "$TEMP_DIR"
cp -r templates "$TEMP_DIR"
cp -r bin "$TEMP_DIR"

tar -czvf "$TAR_FILE" -C "$TEMP_DIR" .

gsutil cp test.sh "$TAR_FILE" "$GSUTIL_URI"

rm -rf "$TEMP_DIR"
rm "$TAR_FILE"