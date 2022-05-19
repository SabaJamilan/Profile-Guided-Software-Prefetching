#python3 max-branch-freq.py dump-brstack-bfs.txt 0x401406 0x4013a0 0x4013ef 0x4013d0
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


dict = {}
seen = False

inner_freq = 0
inner_cycle = 0

seen_inner = False

with open(sys.argv[1]) as file_in:
    
#    src = sys.argv[2]
 #   dst = sys.argv[3]

    inner_src = sys.argv[2]
    inner_dst = sys.argv[3]
    PC = sys.argv[4]
    
    output_file= str(inner_src) + "-" + str(inner_dst) + "-dist-between-2-occur-outerloop-PC-"+str(PC)+".txt"
    
    with open(output_file, 'wt') as out:
        for line in file_in:
            for branch_record in line.split():
                if '/' not in branch_record:
                    continue
                branch_rec_parts = branch_record.split('/')
                cur_src = branch_rec_parts[0]
                cur_dst = branch_rec_parts[1]
                cycle  = int(branch_rec_parts[-1])
                
                if cur_src != inner_src and cur_dst != inner_src:
                    if seen_inner == True:
                        if inner_freq > 1:
                           out.write(str(inner_cycle) + "\n")
                    inner_freq = 0
                    inner_cycle = 0
                    seen_inner = False
                        
                if cur_src == inner_src and cur_dst == inner_dst:
                    seen_inner = True
                    inner_freq = inner_freq + 1
                    inner_cycle = inner_cycle + cycle
#                    print("cycle: ", cycle)




