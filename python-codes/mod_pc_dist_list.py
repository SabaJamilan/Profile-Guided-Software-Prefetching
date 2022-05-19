import sys

# opening the file in read mode
file = open(sys.argv[1], "r")
fout = open(sys.argv[2], "w")
replacement = ""
dist= sys.argv[3]


# using the for loop
for line in file:
    line = line.strip()
    changes = ","+str(dist)+",nta"
    replacement = line + changes + "\n"
    fout.write(replacement)

file.close()
fout.close()
