import pandas as pd
import matplotlib.pyplot as plt 
import seaborn as sns 
from collections import Counter
import sys 
import glob
import re
import matplotlib.cm as cm
import numpy as np
import pprint 
import collections

src=sys.argv[2]
dst=sys.argv[3]
pc=sys.argv[4]
lines=[]

with open(sys.argv[1]) as file_in:
    for line in file_in:
        if line !="\n":
            lines.append(line)

sum=0
total_avg=0

output_file= str(src)+"-"+str(dst)+ "-avg-inner-iters-PC-"+str(pc)+".txt"
with open (output_file, 'a') as out:
    for i in range(0, len(lines)-1):
        sum = sum + float(lines[i])
    if len(lines) !=0:
        total_avg = sum/len(lines)
        out.write(str(total_avg)+ "\n") 

