import sys
import re

pc=0
percent=[]
pc_list=[]
max=0.00
pos_in_line=0

funcNum =0
percentSum=0
funcList=[]
percentList=[]
bench=sys.argv[4]


with open(sys.argv[1]) as file_in:
    lines = []
    for line in file_in:
        if(funcNum<20):
           if line.split()[0]=="#":
              continue
           elif line.split()[-3]==bench and line.split()[-4]==bench:
              print("     ", line)
              funcList.append(line.split()[-1])
              #percentList.append(line.split()[0])
              #print(line.split()[0][:2])
              if line.split()[0][1]!= "." :
                percentSum= percentSum + int(line.split()[0][:2])
                percentList.append(line.split()[0][:2])
              else:
                percentSum= percentSum + int(line.split()[0][:1])
                percentList.append(line.split()[0][:1])
              #print("sum:",percentSum)
           funcNum=funcNum+1


output_file_func_percent_list = open(sys.argv[2], "a")
output_file_func_list = open(sys.argv[3], "a")

sum =0


if percentList!=[]:
 if(int(percentList[0])<10):
    output_file_func_percent_list.write("percent:   "+ str(percentList[0])+ "        func: "+ str(funcList[0])+"\n")
    output_file_func_list.write(str(funcList[0])+"\n")
 else:
    for x in range(0,len(funcList)):
        #print("funcList[x]:   ", funcList[x])
        #while(sum< 60):
        #while(sum< 90):
        if sum< 60:
            output_file_func_percent_list.write("percent:   "+ str(percentList[x])+ "        func: "+ str(funcList[x])+"\n")
            output_file_func_list.write(str(funcList[x])+"\n")
            sum = sum + int(percentList[x])
#            print("func name: ", funcList[x], "    percent: ", percentList[x],"\n")


