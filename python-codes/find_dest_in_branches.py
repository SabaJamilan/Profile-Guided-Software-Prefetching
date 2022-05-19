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

pc=sys.argv[3]
PC_src = sys.argv[2]
#PC_str ='0000000000'+str(PC_src)
if len(PC_src) <8: 
    PC_str ='0000000000'+str(PC_src)
else:
    PC_str =str(PC_src)
#print("PC_str: ", PC_str)

lines=[]

with open(sys.argv[1]) as file_in:
    for line in file_in:
        if line !="\n":
            if "insn:" in line.split():
                lines.append(line)

branch_in_rec=[]
output_file= "in-branches-dest-PC-"+str(pc)+".txt"
with open (output_file, 'a') as out2:
    for i in range(0, len(lines)-1):
        for branch_record in lines[i].split():
            if i+1 < len(lines):
                if PC_str in branch_record:
                    if len(lines[i+1]) >0:
                        branch_in_rec.append(lines[i+1].split()[0])

    counter=collections.Counter(branch_in_rec)
    index=0
    #for key, value in counter.items():
    for key, value in counter.most_common(1000):
       if index==0:
           if key[-7]=='0' and key[-8]=='0' :
               #print("key -7: ", key)
               out2.write(str(key[-6:])+ "\n")
           else:
               out2.write(str(key[-12:])+ "\n")
           #print("inner branch dest: ", key, "   freq: ", value)
       index= index+1

