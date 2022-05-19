import sys
import re

IPC_location =0
exe_location =0
graph_location =0
n_location =0
d_location =0
inst_location =0
llc_loaction =0
swPref_location =0
LoadHints_location =0

IPC_value=0
exe_value=0
graph_value=0
n_value=0
d_value=0
inst_value =0
llc_value =0
swPref_value =0
LoadHints_value =0


with open(sys.argv[1]) as file_in:
    lines = []
    for line in file_in:
        lines.append(line.strip())
        if 'insn per cycle' in line:
            for value in line.split():
                if(IPC_location ==3):
                    IPC_value=value
                IPC_location+=1
        if 'seconds user' in line:
            for value in line.split():
                if(exe_location ==0):
                    exe_value=value
                exe_location+=1
        if 'Input_graph' in line:
            for value in line.split():
                if(graph_location ==2):
                    graph_value=value
                graph_location+=1
        if 'Nodes' in line:
            for value in line.split():
                #print("v: ", value)
                if(n_location ==1):
                    n_value=value
                    #print("n_value: ", n_value)
                n_location+=1
        if 'Degree' in line:
            for value in line.split():
                if(d_location ==1):
                    d_value=value
                    #print("d_value: ", d_value)
                d_location+=1



        if 'LLC-load-misses' in line:
            for value in line.split():
                if(llc_loaction ==0):
                    llc_value=value
                llc_loaction+=1
        if 'instructions' in line:
            for value in line.split():
                if(inst_location ==0):
                    inst_value=value
                inst_location+=1
        if 'SW_PREFETCH_ACCESS.T0' in line:
            for value in line.split():
                if(swPref_location ==0):
                    swPref_value=value
                swPref_location+=1
        if 'LOAD_HIT_PRE.SW_PF' in line:
            for value in line.split():
                if(LoadHints_location ==0):
                    LoadHints_value=value
                LoadHints_location+=1


output_file = open(sys.argv[2], "a")
if d_location == 0:
    output_file.write("baseline/"+str(graph_value)+"/"+str(exe_value)+"/"+str(IPC_value)+"/"+str(inst_value)+"/"+str(llc_value)+"/"+str(swPref_value)+"/"+str(LoadHints_value)+"\n")

else:
    output_file.write("baseline/N"+str(n_value)+"-D"+str(d_value)+"/"+str(exe_value)+"/"+str(IPC_value)+"/"+str(inst_value)+"/"+str(llc_value)+"/"+str(swPref_value)+"/"+str(LoadHints_value)+"\n")





#print("======================")

#for x in range(0,len(lines)):
    #print(lines[x])
