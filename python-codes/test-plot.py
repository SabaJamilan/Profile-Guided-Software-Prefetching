import pandas as pd 
import numpy as np
from matplotlib import pyplot as plt
from scipy.signal import find_peaks_cwt
from collections import Counter
import peakutils
from scipy.signal import find_peaks
import sys

data = np.loadtxt(sys.argv[1], dtype=int)
#data = pd.read_csv("0x4015ad-0x401560-cycles-PC-401599-new.csv")
com_dist_value=[]
com_dist_freq=[]
distances=Counter(data)
for key,value in distances.most_common(100000000):
    if (value > 0):
        com_dist_value.append(key)
        com_dist_freq.append(value)


#print(len(com_dist_value))

output_file=str(sys.argv[2])+"-test-plot.csv"
with open(output_file, 'wt') as out:
#    out.write('x,y\n')
    for i in range(0, len(com_dist_value)):
        out.write(str(com_dist_value[i])+","+str(com_dist_freq[i])+"\n")


