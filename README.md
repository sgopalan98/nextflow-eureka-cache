## Running Nextflow on Eureka

This is a simple example of how to run a Nextflow pipeline on Eureka with caching enabled.

### Deploy your Nextflow pipeline

1. Clone this repository:

```bash
git clone git@github.com:sgopalan98/nextflow-eureka-cache.git
```

2. Use the `deploy.sh` script to deploy the pipeline:

```bash
cd nextflow-eureka-cache
./deploy.sh --location gs://your-bucket-name/your-folder-name
```

### Run your Nextflow pipeline from Eureka

1. Login to a Eureka HPC Login node:

2. Copy `test.sh` to your Eureka home directory:

```bash
gsutil cp gs://your-bucket-name/your-folder-name/test.sh .
```

3. Run the script to start the Nextflow pipeline:

a. Without caching:
```bash
sbatch test.sh --location "gs://your-bucket-name/your-folder-name"
```

b. With caching:
```bash
sbatch test.sh --location "gs://your-bucket-name/your-folder-name" --resume-location "gs://your-bucket-name/your-folder-name/nf-logs/log-directory"
```


