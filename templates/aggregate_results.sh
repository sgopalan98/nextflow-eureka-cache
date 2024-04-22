#!/bin/bash

set -e # fail script on any error


umask 0077
ulimit -n 8192
current_dir=$(pwd)
temp=$(mktemp -d)
cp !{processed_files} $temp/
cd $temp

# Aggregate results
FULL_PATH=$(which aggregate_results.py)
cp $FULL_PATH .
python aggregate_results.py 

cp aggregated* $current_dir/
