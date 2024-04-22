#!/usr/bin/env python

# get all files in the current directory startign with processed

import os
import sys

files = os.listdir('.')
files = [f for f in files if f.startswith('processed')]

with open("aggregated_results.txt", 'w') as f:
    for file in files:
        with open(file, 'r') as g:
            line = g.readline()
            f.write(line)

