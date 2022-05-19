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

#print("    PC in code: ",PC_str )

with open(sys.argv[1]) as file_in:
    output_file= "temp-"+str(PC)+".txt"
    with open (output_file, 'wt') as out:
        for line in file_in:
            for branch_record in line.split():
                if '#' in branch_record:
                    out.write(str(line) + "\n")
                    lines.append(line)
                if PC_str in branch_record:
                    out.write(str(line) + "\n")
                    lines.append(line)

branch_in_rec=[]
branch_in_frequency=[]

output_file= "in-branches-src-PC-"+str(PC)+".txt"
#with open (output_file, 'wt') as out2:
with open (output_file, 'a') as out2:
    for i in range(0, len(lines)):
        for branch_record in lines[i].split():
            if PC_str in branch_record:
                branch_in_rec.append(lines[i-1].split()[0])

    counter=collections.Counter(branch_in_rec)
    #print("counter: ",counter)
    index=0
    #for key, value in counter.items():
    for key, value in counter.most_common(1000):
       if index==0 or index==1:
           if key[-7]=='0' and  key[-8]=='0' :
               out2.write(str(key[-6:])+ "\n")
           else:
               out2.write(str(key[-12:])+ "\n")

           #print("inner branch src: ", key, "   freq: ", value)
       index= index+1

