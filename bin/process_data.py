#!/usr/bin/env python
import sys

file = sys.argv[1]
file = file.split('/')[-1]
print("the file is ", file)
print("new file is ", "processed_" + file)
with open("processed_" + file, 'w') as f:
    line = "PROCESSED OUTPUT is " + file + "\n"
    f.write(line)
