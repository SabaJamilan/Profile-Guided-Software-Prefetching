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

outer_loop_counter = 0
cycle_sum = 0
PC=sys.argv[4]

with open(sys.argv[1]) as file_in:
    
    src = sys.argv[2]
    dst = sys.argv[3]

    
    output_file= str(src) + "-" + str(dst) + "-cycles-PC-"+str(PC)+"-new.txt"
    with open (output_file, 'wt') as out:
        for line in file_in:
            for branch_record in line.split():
                if '/' not in branch_record:
                    continue
                branch_rec_parts = branch_record.split('/')
                cur_src = branch_rec_parts[0]
                cur_dst = branch_rec_parts[1]
                cycle  = int(branch_rec_parts[-1])
                
                if cur_src == src and cur_dst == dst:
                    if seen == False:
                        seen = True
                        cycle_sum = cycle_sum + cycle
                    else:
                        #if(cycle_sum>2 ):
                        out.write(str(cycle_sum) + "\n")
                        cycle_sum = cycle

                elif seen == True:
                    cycle_sum = cycle_sum + cycle

