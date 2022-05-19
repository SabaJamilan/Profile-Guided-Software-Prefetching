import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from collections import Counter
import sys
import glob
import re
import matplotlib.cm as cm
import numpy as np
from matplotlib import pyplot as plt
from scipy.signal import find_peaks_cwt



num_files=0
names = ['dist']

#for fname in glob.glob("401e49v1-B512MW32-baseline-awk.csv"):
for fname in glob.glob(sys.argv[1]):
    print(fname+"\n")
    a=re.split("[-.]", fname)[-2]
    print("a: ", a)
    globals()[f"data_{a}"]= pd.read_csv(fname)
    globals()[f"data_{a}"].columns = names
    num_files+=1
    distances=Counter(globals()[f"data_{a}"]['dist'])
    globals()[f"com_dist_value_{a}"]=[]
    globals()[f"com_dist_freq_{a}"]=[]
    
    for key,value in distances.most_common(100000000):
      if (value > 0):
        globals()[f"com_dist_value_{a}"].append(key)
        globals()[f"com_dist_freq_{a}"].append(value)
      

#print(globals()[f"com_dist_value_{a}"])
#print(globals()[f"com_dist_freq_{a}"])

plt.rcParams.update({'figure.figsize':(10,8), 'figure.dpi':100})

#plt.ylim(0,500)
plt.ylim(0,5000)
plt.xlim(0,2000)
#plt.xlim(0,250)
#plt.xlim(250,500)
#colors = cm.rainbow(np.linspace(0, 1, 20))
colors = ["red", "gold", "darkorchid", "royalblue", "chartreuse", "darkorange","dimgray" , "lightgreen", "rosybrown", "deepskyblue"]
#plt.yticks(np.arange(0, 500, 4000), fontsize=14 )
plt.yticks(fontsize=14)
plt.xticks(fontsize=14)

#plt.scatter(com_dist_value_step3, com_dist_freq_step3 ,s=12,color=colors[0],label ='bfs-N80K-D8')
#plt.scatter(com_dist_value_step2, com_dist_freq_step2 ,s=12,color=colors[0],label ='bfs-N80K-D8')
#peaks = find_peaks_cwt(com_dist_value_new, com_dist_freq_new)
plt.scatter(com_dist_value_new, com_dist_freq_new ,s=12,color=colors[0],label ='pr-com-liveJouranl')
#plt.scatter(peaks,com_dist_freq_new[peaks] ,"x")
#peaks = find_peaks_cwt(com_dist_value_new, com_dist_freq_new, widths=np.ones(data.shape)*2)-1


#plt.scatter(com_dist_value_w4, com_dist_freq_w4 ,s=10,color=colors[0],label ='base_arr_size:64M , work_arr_size:4')
#plt.scatter(com_dist_value_w8, com_dist_freq_w8 ,s=10,color=colors[6],label ='base_arr_size:64M , work_arr_size:8')
#plt.scatter(com_dist_value_w16, com_dist_freq_w16 ,s=10,color=colors[2],label ='base_arr_size:64M , work_arr_size:16')
#plt.scatter(com_dist_value_w32, com_dist_freq_w32 ,s=10,color=colors[3],label ='base_arr_size:64M , work_arr_size:32')
#plt.scatter(com_dist_value_w64, com_dist_freq_w64 ,s=10,color=colors[4],label ='base_arr_size:64M , work_arr_size:64')
#plt.scatter(com_dist_value_w128, com_dist_freq_w128 ,s=10,color=colors[5],label ='base_arr_size:64M , work_arr_size:128')
#plt.scatter(com_dist_value_w256, com_dist_freq_w256 ,s=10,color=colors[6],label ='base_arr_size:64M , work_arr_size:256')
#plt.scatter(com_dist_value_w512, com_dist_freq_w512 ,s=10,color=colors[7],label ='base_arr_size:64M , work_arr_size:512')
#plt.scatter(com_dist_value_w1024, com_dist_freq_w1024 ,s=10,color=colors[2],label ='base_arr_size:64M , work_arr_size:1024')
#plt.scatter(com_dist_value_w2048, com_dist_freq_w2048 ,s=10,color=colors[2],label ='base_arr_size:64M , work_arr_size:2048')
#plt.scatter(com_dist_value_B1GW64, com_dist_freq_B1GW64 ,s=10,color=colors[3],label ='base_arr_size:1G , work_arr_size:64')
#plt.scatter(com_dist_value_B1GW128, com_dist_freq_B1GW128 ,s=10,color=colors[5],label ='base_arr_size:1G , work_arr_size:128')
#plt.scatter(com_dist_value_B1GW256, com_dist_freq_B1GW256 ,s=10,color=colors[6],label ='base_arr_size:1G , work_arr_size:256')

#plt.scatter(com_dist_value_B512MW32, com_dist_freq_B512MW32 ,s=10,color=colors[1],label ='base_arr_size:512M , work_arr_size:32')
#plt.scatter(com_dist_value_B512MW64, com_dist_freq_B512MW64 ,s=10,color=colors[2],label ='base_arr_size:512M , work_arr_size:64')
#plt.scatter(com_dist_value_B512MW128, com_dist_freq_B512MW128 ,s=10,color=colors[0],label ='base_arr_size:512M , work_arr_size:128')
#plt.scatter(com_dist_value_B512MW256, com_dist_freq_B512MW256 ,s=10,color=colors[7],label ='base_arr_size:512M , work_arr_size:256')


#plt.scatter(com_dist_value_B2MW32, com_dist_freq_B2MW32 ,s=10,color=colors[1],label ='base_arr_size:2M , work_arr_size:32')
#plt.scatter(com_dist_value_B2MW64, com_dist_freq_B2MW64 ,s=10,color=colors[2],label ='base_arr_size:2M , work_arr_size:64')
#plt.scatter(com_dist_value_B2MW128, com_dist_freq_B2MW128 ,s=10,color=colors[0],label ='base_arr_size:2M , work_arr_size:128')
#plt.scatter(com_dist_value_B2MW256, com_dist_freq_B2MW256 ,s=10,color=colors[7],label ='base_arr_size:2M , work_arr_size:256')

#plt.scatter(com_dist_value_baseline, com_dist_freq_baseline ,s=10,color=colors[0],label ='baseline')
#plt.scatter(com_dist_value_llc, com_dist_freq_llc ,s=10,color=colors[3],label ='llc')



#plt.scatter(com_dist_value_4k, com_dist_freq_4k ,s=10,color=colors[1],label ='4k')
#plt.scatter(com_dist_value_64k, com_dist_freq_64k ,s=10,color=colors[3],label ='64k')
#plt.scatter(com_dist_value_512k, com_dist_freq_512k ,s=10,color=colors[8],label ='512k')
#plt.scatter(com_dist_value_1M, com_dist_freq_1M ,s=10,color=colors[9],label ='1M')
#plt.scatter(com_dist_value_4M, com_dist_freq_4M ,s=10,color=colors[4],label ='4M')
#plt.scatter(com_dist_value_8M, com_dist_freq_8M ,s=10,color=colors[7],label ='8M')
#plt.scatter(com_dist_value_64M, com_dist_freq_64M ,s=10,color=colors[0],label ='64M')
#plt.scatter(com_dist_value_256M, com_dist_freq_256M ,s=10,color=colors[2],label ='256M')
#plt.scatter(com_dist_value_512M, com_dist_freq_512M ,s=10,color=colors[5],label ='512M')
#plt.scatter(com_dist_value_1G, com_dist_freq_1G ,s=10,color=colors[6],label ='1G')


plt.xlabel('Cycles',weight='bold',fontsize=18)
plt.ylabel('Number of Occurrences', weight='bold', fontsize=18)

plt.grid (True)
plt.legend (bbox_to_anchor = (1, 1), fontsize =18) # Display labels representing data groups outside the graph

plt.title('The basic block execution time in terms of cycle from LBR samples', weight='bold', fontsize=18)
plt.savefig(sys.argv[2]+".png")




