import sys
import re

BackEnd_location =0
BackEnd_MemEnd_location =0
DRAM_location =0
L3_location =0

BackEnd_value=0
BackEnd_MemEnd_value=0
DRAM_value=0
L3_value=0



with open(sys.argv[1]) as file_in:
    lines = []
    for line in file_in:
        lines.append(line.strip())
        if 'Backend_Bound' and "BE" in line.strip():
            for value in line.split():
                if(BackEnd_location ==5):
                    BackEnd_value=value
                BackEnd_location+=1
        if 'Backend_Bound.Memory_Bound' in line.strip(): 
             if "S0-C0-" not in line.strip():
                 for value in line.split():
                      if(BackEnd_MemEnd_location ==5):
                          BackEnd_MemEnd_value=value
                      BackEnd_MemEnd_location+=1
        if 'Backend_Bound.Memory_Bound.L3_Bound' in line.strip():
            if 'S0-C0-T0' in line.strip():
                 for value in line.split():
                      if(L3_location ==5):
                          L3_value=value
                      L3_location+=1
        if 'Backend_Bound.Memory_Bound.DRAM_Bound'in line.strip():
            if 'S0-C0-T0' in line.strip():
                 for value in line.split():
                      if(DRAM_location ==5):
                          DRAM_value=value
                      DRAM_location+=1
 


output_file = open(sys.argv[2], "a")
output_file.write(str(BackEnd_value)+"/"+str(BackEnd_MemEnd_value)+"/"+str(L3_value)+"/"+str(DRAM_value)+"\n")


#output_file.write("baseline/"+str(graph_value)+"/"+str(exe_value)+"/"+str(IPC_value)+"/"+str(inst_value)+"/"+str(llc_value)+"/"+str(swPref_value)+"/"+str(LoadHints_value)+"\n")






#print("======================")

#for x in range(0,len(lines)):
    #print(lines[x])
