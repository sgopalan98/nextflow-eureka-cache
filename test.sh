#!/bin/bash

#SBATCH -p c2s4
#SBATCH --job-name=issue-test
#SBATCH --out=issue-test%A.log
#SBATCH --error=issue-test%A.err

set -e # Fail script if anything fails


location=""
resume_location=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --location)
            location="$2"
            shift 2
            ;;
        --resume-location)
            resume_location="$2"
            shift 2
            ;;
        *)
            echo "Error: Invalid parameter: $1"
            exit 1
            ;;
    esac
done

if [[ -z "$location" ]]; then
    echo "Error: location parameter is required."
    echo "Usage: hipv_rgc.sh --location <gcs_location>"
    exit 1
fi


if [ ! -f test.tar.gz ]; then
    echo "Downloading test.tar.gz file from $location"
    gsutil cp "$location/test.tar.gz" .
else
    local_hash=$(gsutil hash -h test.tar.gz | awk '/md5/ {printf $3}')
    remote_hash=$(gsutil hash -h "$location/test.tar.gz" | awk '/md5/ {printf $3}')
    if [ "$local_hash" != "$remote_hash" ]; then
        echo "Local and remote hashes are different. Downloading test.tar.gz file from $location"
        gsutil cp "$location/test.tar.gz" .
    else
        echo "Local and remote hashes are the same. Skipping download."
    fi
fi

# if nf_execution folder exists, exit the script
if [ -d nf_execution ]; then
    echo "There is already a script running. Please wait for it to finish."
    exit 1
fi

# create a new folder for the nextflow execution
new_folder="nf_execution"
mkdir -p "$new_folder"
# if resume_location exists, gsutil cp the resume_location contents to the new_folder
if [ -n "$resume_location" ]; then
    gsutil -m cp -r "$resume_location/.nextflow" "$new_folder/"
    gsutil -m cp -r "$resume_location/work" "$new_folder/"
fi
cp test.tar.gz "$new_folder"
cd "$new_folder"

# Extracting the tar file.
tar -xf test.tar.gz
set +e

nextflow run main.nf -resume -with-trace trace.txt -with-timeline timeline.html -with-report report.html -dump-hashes 

debug_output_folder="$(TZ=America/Denver date +"%m-%d-%Y-%T") HIPV_pipeline_debug_output"
gsutil -m cp -r . "$location/nf_logs/$debug_output_folder/"

cd ..
rm -rf "$new_folder"