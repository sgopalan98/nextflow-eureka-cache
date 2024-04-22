#! /usr/bin/env python

import sys
chr = sys.argv[1]

with open(chr, 'w') as f:
    line = "OUTPUT is " + chr + "\n"
    f.write(line)
