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


PC = sys.argv[2]
if len(PC) <8:
    PC_str ='0000000000'+str(PC)
else:
    PC_str =str(PC)
lines=[]

#print("PC in code: ",PC_str )
output_file= "filter-"+str(PC)+".txt"
count =0
prev_count =0
prev=''

with open(sys.argv[1]) as file_in:
    with open (output_file, 'wt') as out:
        for line in file_in:
            for branch_record in line.split():
                if '/' in branch_record:
                    prev=line
                    prev_count=count
                    #out.write(str(line))
                    #lines.append(line)
                    count=count+1 

                if PC_str in branch_record:
                    if count == (prev_count+1):
                       #print(prev.split()[0][0])
                       if prev.split()[0][0]!='f':
                           if int(prev.split()[0][0])==4:
                               out.write(prev)
                               lines.append(line)
                    count=count+1

