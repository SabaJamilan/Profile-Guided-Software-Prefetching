import pandas as pd 
import numpy as np
from matplotlib import pyplot as plt
from scipy.signal import find_peaks_cwt
from collections import Counter
import peakutils
from scipy.signal import find_peaks
import matplotlib.pyplot as plt

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


output_file=str(sys.argv[2])+"-sorted-data.csv"
with open(output_file, 'wt') as out:
#    out.write('x,y\n')
    for i in range(0, len(col1)):
        for x in range(0, len(col1)):
            if int(col1[x])==i:
                out.write(str(i)+","+str(col2[x])+"\n")   



