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
output_file= "first-filter-"+str(PC)+".txt"

seen_1=False
pc_seen =False

count =0
prev_count =0
prev=''

with open(sys.argv[1]) as file_in:
    with open (output_file, 'wt') as out:
        for line in file_in:
            #for branch_record in line.split():
                #if '#' in branch_record and not pc_seen and not seen_1:
                #if '#' in line.split() and not pc_seen and not seen_1:
                if '#' in line.split() and not pc_seen and not seen_1:
                    #print("  1")
                    lines.append(line)
                    seen_1=True
                #if seen_1 and '#' not in branch_record:
                if seen_1 and '#' not in line.split() and PC_str not in line.split():
                    #print("  2")
                    lines.append(line)
                #if PC_str in branch_record and seen_1:
                if PC_str in line.split() and seen_1:
                    #print("  3")
                    pc_seen=True
                    lines.append(line)
                #if'#' in branch_record and pc_seen and seen_1:
                if'#' in line.split() and pc_seen and seen_1:
                    #print("  4")
                    for i in lines:
                        out.write(i)
                    pc_seen=False
                    #seen_1=False
                    lines=[]
                    lines.append(line)
                #if'#' in branch_record and not pc_seen and seen_1:
                if'#' in line.split() and not pc_seen and seen_1:
 #                   print("line: ", line)
  #                  print("  5")
   #                 pc_seen=False
#                    seen_1=False
                    lines=[]
                    lines.append(line)

