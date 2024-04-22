#!/bin/bash


CHR=!{chr}

set -e # fail script on any error

umask 0077
ulimit -n 8192
current_dir=$(pwd)
temp=$(mktemp -d)
cp ${CHR} $temp/
cd $temp

# Process data
FULL_PATH=$(which process_data.py)
cp $FULL_PATH .
python process_data.py ${CHR}
ls
cp processed* $current_dir/
