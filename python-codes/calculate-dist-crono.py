import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from collections import Counter
import sys
import glob
import re
import matplotlib.cm as cm
import numpy as np

num_files=0
names = ['dist']
#print("\n")
PC = sys.argv[2]

for fname in glob.glob(sys.argv[1]):
    #print("Database Name:  "+fname+"\n")
    a=re.split("[-.]", fname)[-3]
    globals()[f"data_{a}"]= pd.read_csv(fname)
    globals()[f"data_{a}"].columns = names
    num_files+=1
    distances=Counter(globals()[f"data_{a}"]['dist'])
    globals()[f"com_dist_value_{a}"]=[]
    globals()[f"com_dist_freq_{a}"]=[]
    total=0
    for key,value in distances.most_common(100000000):
        if (value > 0): 
            globals()[f"com_dist_value_{a}"].append(key)
            globals()[f"com_dist_freq_{a}"].append(value)
            total += value   

    DataPoint1 =sys.argv[3]
    DataPoint2= sys.argv[4]
 #   print("DataPoint 1 : ", DataPoint1)
  #  print("DataPoint 2 : ", DataPoint2)
    total_freq_1=0
    total_sum_1=0
    total_avg_1=0
 
    for x in range(0, len( globals()[f"com_dist_value_{a}"])):
        if(globals()[f"com_dist_value_{a}"][x]< int(DataPoint1)):
            total_sum_1+=globals()[f"com_dist_value_{a}"][x]*globals()[f"com_dist_freq_{a}"][x]
            total_freq_1+=globals()[f"com_dist_freq_{a}"][x]
    total_avg_1= total_sum_1/total_freq_1
    #print("The average value before data point1: : ", total_avg_1)


    total_freq_2=0
    total_sum_2=0
    total_avg_2=0
 
    for x in range(0, len( globals()[f"com_dist_value_{a}"])):
        if(globals()[f"com_dist_value_{a}"][x]>= int(DataPoint2)):
            total_sum_2+=globals()[f"com_dist_value_{a}"][x]*globals()[f"com_dist_freq_{a}"][x]
            total_freq_2+=globals()[f"com_dist_freq_{a}"][x]
    total_avg_2= total_sum_2/total_freq_2
    #print("The average value after data point2:  ", total_avg_2)

    a=0
    preftech_dist1=0
    preftech_dist2=0

    
    output_file=str(sys.argv[5])+"-ALL-dist1.csv"
    with open(output_file, 'a') as out:
        #print("---------------------")
        if total_avg_1 !=0:
            prefetch_dist1 = total_avg_2/total_avg_1
#            print(prefetch_dist1)
            out.write(str(PC)+","+str(round(prefetch_dist1))+",nta\n")





    #print("prefetch dist1 = ",prefetch_dist1 )

    a=0
    output_file2=str(sys.argv[5])+"-ALL-dist2.csv"
    with open(output_file2, 'a') as out2:
        prefetch_dist2 = (int(DataPoint2)-int(DataPoint1))/int(DataPoint1)
        #print(round(preftech_dist2))
        print(round(prefetch_dist2))
        a=round(prefetch_dist2)*1000
        out2.write(str(PC)+","+str(a)+",nta\n")

    




