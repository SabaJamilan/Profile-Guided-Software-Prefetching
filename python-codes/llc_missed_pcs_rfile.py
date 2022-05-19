import sys
import re

pc=0
percent=[]
pc_list=[]
max=0.00
pos_in_line=0

with open(sys.argv[1]) as file_in:
    lines = []
    for line in file_in:
        lines.append(line.strip())
        if '40'  in line:
        #if '4'  in line.split()[2]:
            if '.' in line:
                #print(line)
                #print(re.sub(r"\s+", "", line)
                #for value in line.split():
                #print(line.split()[0])
                if(int(float(line.split()[0]))> 0):
                    percent_value =int(float(line.split()[0]))
                    percent.append(percent_value)
                    pc_value=line.split()[2]
                    pc_list.append(pc_value[:-1])
                    if(max < percent_value):
                        max = percent_value
                        pc = line.split()[2][:-1]
#                        print("max: ",max)
 #                       print("pc: ",pc)


sum_percent =0

output_file_pc_list = open(sys.argv[2], "a")
output_file_most_missed_pc = open(sys.argv[3], "a")

sorted_percent= sorted(percent,reverse=True)
for x in range(0,len(sorted_percent)):
    #print("sorted_percent: ", sorted_percent[x])
    for y in range(0,len(percent)):

        #if(percent[y]==sorted_percent[x] and sum_percent < 40):
        if(percent[y]==sorted_percent[x] and sum_percent < 70):
            print("          PC: ", pc_list[y], "      percent:   ", percent[y])
            sum_percent = sum_percent + percent[y]
            output_file_pc_list.write("percent:   "+ str(percent[y])+ "      PC:   "+ str(pc_list[y])+"\n")
            output_file_most_missed_pc.write(str(pc_list[y])+"\n")


#for x in range(0,len(pc_list)):
 #   print("percent: ", percent[x])
  #  output_file_pc_list.write("percent: "+ str(percent[x])+ " pc: "+ str(pc_list[x])+"\n")

#output_file_most_missed_pc.write(pc)
