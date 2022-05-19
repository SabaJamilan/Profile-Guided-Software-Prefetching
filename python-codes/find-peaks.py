import pandas as pd 
import numpy as np
from matplotlib import pyplot as plt
from scipy.signal import find_peaks_cwt
from collections import Counter
import peakutils
from scipy.signal import find_peaks
import matplotlib.pyplot as plt
import scipy.signal as signal
#import plotly.plotly as py
import plotly.graph_objs as go
#from plotly.tools import FigureFactory as FF

import numpy as np
import pandas as pd
import scipy
import peakutils
import sys


estimated_data = pd.read_csv(sys.argv[1], header=None)

col1 = estimated_data[:][0] # First column data
col2 = estimated_data[:][1] # Second column data

#print("col1: ",col1)
#print("col2: ", col2)



plt.ylim(0,5000)
plt.xlim(0,2000)

col3=[]
col4=[]
#for i in range(0,len(col2)-100):
 #   if i==0 and col2[i]-col2[i+100]>col2[i]/2:
  #      col3.append(col1[i])
   # elif i>100:
    #    if col2[i]-col2[i+100]<-col2[i]/2 and col2[i]-col2[i-100]>col2[i]/2:
     #       col3.append(col1[i])

#for i in col3:
 #   print(i)
  #  for x in range(0, len(col1)):
   #     if col1[x]==i:
    #        col4.append(col2[x])



#for i, d in enumerate(data[0:]):
 #   if abs(d_l - d) > dy_lim:
  #      if in_lock:
   #         targets.append(i_l)
    #        targets.append(i + 1)
     #       in_lock = False
     #   i_l, d_l = i, d
   # else:
        #in_lock = True



#for t in targets:
 #   print(t)



peaks, _ = find_peaks(col2, threshold=300)
#print(peaks)


#peakidx = signal.find_peaks_cwt(col2, np.arange(15,20), noise_perc=0.1)
peakidx = signal.find_peaks_cwt(col2[20:],  np.arange(5,15), noise_perc=0.1)
#peakidx = signal.find_peaks_cwt(col2[5:],  order=5, noise_perc=0.1)-1
#print(peakidx)
#print(col2[1])


plt.scatter(col1,col2, lw=0.4, alpha=0.4 )
#plt.scatter(peakidx,col2[peakidx], color='orange' )
#plt.scatter(col3, col4 ,color='orange')

peaks=[]
i=0


while i< (len(peakidx)-1):
    if peakidx[i+1]-peakidx[i]< 200:
        if col2[peakidx[i]]> col2[peakidx[i+1]]:
            peaks.append(peakidx[i])
            i=i+2
        else:
            peaks.append(peakidx[i+1])
            i=i+2
    else:
        peaks.append(peakidx[i])
        i=i+1
#    print(peaks)

print(col1[peaks])

count=0
sum=0
new_peaks=[]
for i in range(0, len(peaks)):
    if(peaks[i]< 250):
        sum = sum +peaks[i]
        count =count+1
    else:
        new_peaks.append(peaks[i])

if count!=0:
    new_peaks.append(round(sum/count))
#for i in new_peaks:
 #   print("new_peaks: ",new_peaks)

#plt.scatter(peaks,col2[peaks], color='red' )
#plt.scatter(col1[peaks],col2[peaks], color='red' )
plt.scatter(col1[new_peaks],col2[new_peaks], color='red' )


#if new_peaks!=[]:
if len(new_peaks)>3:
  output_file=str(sys.argv[2])+"-peaks.csv"
  with open(output_file, 'wt') as out:
    for i in range(0, len(peaks)):
        out.write(str(col1[peaks[i]])+"\n")
else:
  output_file=str(sys.argv[2])+"-peaks.csv"
  with open(output_file, 'wt') as out:
        out.write("32\n")
        out.write("32\n")
        out.write("1056\n")
        out.write("1056\n")



plt.show()
plt.savefig(str(sys.argv[2])+"-scatter-plot-with-peaks.png")


