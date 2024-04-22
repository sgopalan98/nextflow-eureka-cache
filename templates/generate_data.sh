#!/bin/bash

CHR=!{chr}
set -e # fail script on any error 

umask 0077
ulimit -n 8192
current_dir=$(pwd)
temp=$(mktemp -d)
cd $temp 


# Generate data
FULL_PATH=$(which generate_data.py)
cp $FULL_PATH .
python generate_data.py ${CHR}


cp ${CHR} $current_dir/
