import sys
output_file = open(sys.argv[1], "a")
app_name = sys.argv[2]
graph_name = sys.argv[3]
output_file.write(app_name+"/"+graph_name+"/")

