#!/bin/bash

###How to run:
### create a "results" folder.
### ./scripts/run-CRONO-benchmarks.sh
### You need to fist set the PATHs.
### You can get CRONO benchmark suite fro "https://github.com/masabahmad/CRONO" and set the path to its "app" folder
### You can get the input graphs from SNAP "http://snap.stanford.edu/data/web-Google.html"

####################PATH
benchmark_path=""
results_path=""
input_graphs_path=""
python_codes_path=""
scripts_path=""
LLVM10_buildMyPasses=""

####################INPUT
benchmarks=(bfs dfs bc pagerank sssp)

bfs_input_graphs=(p2p-Gnutella31.txt p2p-Gnutella30.txt loc-brightkite_edges.txt)
bfs_N=(80000 100000 90000)
bfs_DEG=(8 16 10)

pagerank_input_graphs=(web-Google.txt web-BerkStan.txt web-Stanford.txt web-NotreDame.txt roadNet-PA.txt roadNet-CA.txt)
pagerank_N=(100000)
pagerank_DEG=(100)

bc_N=(56384 40000 10000)
bc_DEG=(8 10 1000)

sssp_N=(100000 80000)
sssp_DEG=(5 4)

dfs_N=(800000 900000)
dfs_DEG=(800 400)
####################RUN

python3 $python_codes_path/first_line_perf_rfile.py "CRONO-benchmarks-perf-stats-output.txt"
#python3 $python_codes_path/first_line_toplev.py "CRONO-benchmarks-baseline-toplev-l3-output.txt"


cd $results_path
for benchmark_name in "${benchmarks[@]}"
do
  if [[ "$benchmark_name" == "bfs" ]]
  then
    echo ""
    echo "Compile bfs becnhmark ..."
    bench_dir=$benchmark_name
    mkdir $bench_dir
    cd $bench_dir  
    $LLVM10_buildMyPasses/bin/clang++ -gmlt -std=c++11 -O3  -fdebug-info-for-profiling -Wall $benchmark_path/$benchmark_name/$benchmark_name"_atomic.cc" -S -emit-llvm -o $benchmark_name".ll" 
    $LLVM10_buildMyPasses/bin/clang++ -gmlt -std=c++11 -O3  -fdebug-info-for-profiling -Wall  $benchmark_path/$benchmark_name/$benchmark_name"_atomic.cc" -o $benchmark_name -lpthread -lrt
    cp $scripts_path/capture_PCs_real.sh .
    cp $scripts_path/capture_PCs_syn.sh .
    echo "done!"
    echo""
    for g in "${bfs_input_graphs[@]}"
    do
      gn=${g::-4}
      res_DIR=$benchmark_name"-INPUT-"$gn
      mkdir $res_DIR
      cd $res_DIR
      ./../capture_PCs_real.sh $benchmark_name $g
      cd ..
      ####Top_DOWN
      #TOP_DIR="Toplev-"$benchmark_name"-INPUT-"$gn
      #mkdir $TOP_DIR                                                                                 
      #cd $TOP_DIR
      #echo ""
      #echo ""
      #echo "Toplevel analysis for bfs becnhmark  ..."
      #python3 $python_codes_path/bench_graph_name.py ../../../"CRONO-benchmarks-baseline-toplev-l3-output.txt" $benchmark_name $gn
      #~/pmu-tools/toplev.py --core S0-C0 -l3 -v --no-desc taskset -c 0 -o $benchmark_name"-INPUT-"$gn"-toplev-l3.txt"  -- ./../$benchmark_name 1 1  $input_graphs_path/$g
      #echo "-------"
      #python3 $python_codes_path/toplev_rfile.py $benchmark_name"-INPUT-"$gn"-toplev-l3.txt" ../../../"CRONO-benchmarks-baseline-toplev-l3-output.txt"
      #cd ..


    done
    len=${#bfs_N[@]}
    for (( i=0; i<$len; i++ ))
    do
      res_DIR=$benchmark_name"-INPUT-N"${bfs_N[$i]}"-DEG"${bfs_DEG[$i]}
      mkdir $res_DIR
      cd $res_DIR
      ./../capture_PCs_syn.sh $benchmark_name ${bfs_N[$i]} ${bfs_DEG[$i]}
      cd ..
      ###TOP-DOWN
      #TOP_DIR="Toplev-"$benchmark_name"-INPUT-N"${bfs_N[$i]}"-DEG"${bfs_DEG[$i]}
      #mkdir $TOP_DIR                                                                                 
      #cd $TOP_DIR
      #echo ""
      #echo ""
      #echo "Toplevel analysis for bfs becnhmark  ..."
      #python3 $python_codes_path/bench_graph_name.py ../../../"CRONO-benchmarks-baseline-toplev-l3-output.txt" $benchmark_name "N"${bfs_N[$i]}"-D"${bfs_DEG[$i]}
      #~/pmu-tools/toplev.py --core S0-C0 -l3 -v --no-desc taskset -c 0 -o $benchmark_name"-INPUT-N"${bfs_N[$i]}"-DEG"${bfs_DEG[$i]}"-toplev-l3.txt"  -- ./../$benchmark_name 0 1 ${bfs_N[$i]} ${bfs_DEG[$i]}
      #echo "-------"
      #python3 $python_codes_path/toplev_rfile.py $benchmark_name"-INPUT-N"${bfs_N[$i]}"-DEG"${bfs_DEG[$i]}"-toplev-l3.txt" ../../../"CRONO-benchmarks-baseline-toplev-l3-output.txt"
      #cd ..

    done
    cd ..
  fi


  if [[ "$benchmark_name" == "bc" ]]
  then
    echo ""
    echo "Compile bc becnhmark ..."
    bench_dir=$benchmark_name
    mkdir $bench_dir
    cd $bench_dir  
    $LLVM10_buildMyPasses/bin/clang++ -gmlt -std=c++11 -O3  -fdebug-info-for-profiling -Wall $benchmark_path/$benchmark_name/$benchmark_name".cc" -S -emit-llvm -o $benchmark_name".ll" 
    $LLVM10_buildMyPasses/bin/clang++ -gmlt -std=c++11 -O3  -fdebug-info-for-profiling -Wall  $benchmark_path/$benchmark_name/$benchmark_name".cc" -o $benchmark_name -lpthread -lrt
    cp $scripts_path/capture_PCs_real.sh .
    cp $scripts_path/capture_PCs_syn.sh .
 
    echo "done!"
    echo""
    for g in "${bc_input_graphs[@]}"
    do
      gn=${g::-4}
      res_DIR=$benchmark_name"-INPUT-"$gn
      mkdir $res_DIR
      cd $res_DIR
      ./../capture_PCs_real.sh $benchmark_name $g
      cd ..
      ####TOP-DOWN
      #TOP_DIR="Toplev-"$benchmark_name"-INPUT-"$gn
      #mkdir $TOP_DIR                                                                                 
      #cd $TOP_DIR
      #echo ""
      #echo ""
      #echo "Toplevel analysis bc becnhmark  ..."
      #python3 $python_codes_path/bench_graph_name.py ../../../"CRONO-benchmarks-baseline-toplev-l3-output.txt" $benchmark_name $gn
      #~/pmu-tools/toplev.py --core S0-C0 -l3 -v --no-desc taskset -c 0 -o $benchmark_name"-INPUT-"$gn"-toplev-l3.txt"  -- ./../$benchmark_name 1 1  $input_graphs_path/$g
      #echo "-------"
      #python3 $python_codes_path/toplev_rfile.py $benchmark_name"-INPUT-"$gn"-toplev-l3.txt" ../../../"CRONO-benchmarks-baseline-toplev-l3-output.txt"
      #cd ..
    done
    len=${#bc_N[@]}
    for (( i=0; i<$len; i++ ))
    do
      res_DIR=$benchmark_name"-INPUT-N"${bc_N[$i]}"-DEG"${bc_DEG[$i]}
      mkdir $res_DIR
      cd $res_DIR
      ./../capture_PCs_syn.sh $benchmark_name ${bc_N[$i]} ${bc_DEG[$i]}
      cd ..
      ###TOP-DOWN
      #TOP_DIR="Toplev-"$benchmark_name"-INPUT-N"${bc_N[$i]}"-DEG"${bc_DEG[$i]}
      #mkdir $TOP_DIR                                                                                 
      #cd $TOP_DIR
      #echo ""
      #echo ""
      #echo "Toplevel analysis for bc becnhmark  ..."
      #python3 $python_codes_path/bench_graph_name.py ../../../"CRONO-benchmarks-baseline-toplev-l3-output.txt" $benchmark_name "N"${bc_N[$i]}"-D"${bc_DEG[$i]}
      #~/pmu-tools/toplev.py --core S0-C0 -l3 -v --no-desc taskset -c 0 -o $benchmark_name"-INPUT-N"${bc_N[$i]}"-DEG"${bc_DEG[$i]}"-toplev-l3.txt"  -- ./../$benchmark_name 1 ${bc_N[$i]} ${bc_DEG[$i]}
      #echo "-------"
      #python3 $python_codes_path/toplev_rfile.py $benchmark_name"-INPUT-N"${bc_N[$i]}"-DEG"${bc_DEG[$i]}"-toplev-l3.txt" ../../../"CRONO-benchmarks-baseline-toplev-l3-output.txt"
      #cd ..
    done
    cd ..
  fi


  if [[ "$benchmark_name" == "pagerank" ]]
  then
    echo ""
    echo "Compile pagerank becnhmark ..."
    bench_dir=$benchmark_name
    mkdir $bench_dir
    cd $bench_dir  
    $LLVM10_buildMyPasses/bin/clang++ -gmlt -std=c++11 -O3  -fdebug-info-for-profiling -Wall $benchmark_path/$benchmark_name/$benchmark_name"_lock.cc" -S -emit-llvm -o $benchmark_name".ll" 
    $LLVM10_buildMyPasses/bin/clang++ -gmlt -std=c++11 -O3  -fdebug-info-for-profiling -Wall  $benchmark_path/$benchmark_name/$benchmark_name"_lock.cc" -o $benchmark_name -lpthread -lrt
    cp $scripts_path/capture_PCs_real.sh .
    #cp $scripts_path/capture_PCs_real_prev.sh .
    cp $scripts_path/capture_PCs_syn.sh .
    #cp $scripts_path/capture_PCs_syn_prev.sh .
    echo "done!"
    echo""
    for g in "${pagerank_input_graphs[@]}"
    do
      gn=${g::-4}
      res_DIR=$benchmark_name"-INPUT-"$gn
      mkdir $res_DIR
      cd $res_DIR
      ./../capture_PCs_real.sh $benchmark_name $g
      cd ..
      ######TOP-DOWN
      #TOP_DIR="Toplev-"$benchmark_name"-INPUT-"$gn
      #mkdir $TOP_DIR                                                                                 
      #cd $TOP_DIR
      #echo ""
      #echo ""
      #echo "Toplevel analysis pagerank becnhmark  ..."
      #python3 $python_codes_path/bench_graph_name.py ../../../"CRONO-benchmarks-baseline-toplev-l3-output.txt" $benchmark_name $gn
      #~/pmu-tools/toplev.py --core S0-C0 -l3 -v --no-desc taskset -c 0 -o $benchmark_name"-INPUT-"$gn"-toplev-l3.txt"  -- ./../$benchmark_name 1 1  $input_graphs_path/$g
      #echo "-------"
      #python3 $python_codes_path/toplev_rfile.py $benchmark_name"-INPUT-"$gn"-toplev-l3.txt" ../../../"CRONO-benchmarks-baseline-toplev-l3-output.txt"
      #cd ..

    done
    len=${#pagerank_N[@]}
    for (( i=0; i<$len; i++ ))
    do
      res_DIR=$benchmark_name"-INPUT-N"${pagerank_N[$i]}"-DEG"${pagerank_DEG[$i]}
      mkdir $res_DIR
      cd $res_DIR
      ./../capture_PCs_syn.sh $benchmark_name ${pagerank_N[$i]} ${pagerank_DEG[$i]}
      cd ..
      ######TOP-DOWN
      #TOP_DIR="Toplev-"$benchmark_name"-INPUT-N"${pagerank_N[$i]}"-DEG"${pagerank_DEG[$i]}
      #mkdir $TOP_DIR                                                                                 
      #cd $TOP_DIR
      #echo ""
      #echo ""
      #echo "Toplevel analysis for pagerank becnhmark  ..."
      #python3 $python_codes_path/bench_graph_name.py ../../../"CRONO-benchmarks-baseline-toplev-l3-output.txt" $benchmark_name "N"${pagerank_N[$i]}"-D"${pagerank_DEG[$i]}
      #~/pmu-tools/toplev.py --core S0-C0 -l3 -v --no-desc taskset -c 0 -o $benchmark_name"-INPUT-N"${bc_N[$i]}"-DEG"${bc_DEG[$i]}"-toplev-l3.txt"  -- ./../$benchmark_name 0 1 ${pagerank_N[$i]} ${pagerank_DEG[$i]}
      #echo "-------"
      #python3 $python_codes_path/toplev_rfile.py $benchmark_name"-INPUT-N"${pagerank_N[$i]}"-DEG"${pagerank_DEG[$i]}"-toplev-l3.txt" ../../../"CRONO-benchmarks-baseline-toplev-l3-output.txt"
      #cd ..
 

    done
    cd ..
  fi

  if [[ "$benchmark_name" == "sssp" ]]
  then
    echo "sssp"
    echo ""
    echo "Compile sssp becnhmark ..."
    bench_dir=$benchmark_name
    mkdir $bench_dir
    cd $bench_dir  
    $LLVM10_buildMyPasses/bin/clang -g --std=c++0x -O3  -fdebug-info-for-profiling -Wall -Werror $benchmark_path/$benchmark_name/$benchmark_name"_outer_atomic.cc" -S -emit-llvm -o $benchmark_name".ll" 
    $LLVM10_buildMyPasses/bin/clang -g --std=c++0x -O3  -fdebug-info-for-profiling  -Wall -Werror $benchmark_name".ll" -c
    $LLVM10_buildMyPasses/bin/clang -g --std=c++0x -O3  -fdebug-info-for-profiling -Wall -Werror $benchmark_name".o" -o $benchmark_name -lpthread -lrt
    cp $scripts_path/capture_PCs_real.sh .
    cp $scripts_path/capture_PCs_syn.sh .
    #cp $scripts_path/capture_PCs_real_prev.sh .
    #cp $scripts_path/capture_PCs_syn_prev.sh .
    echo "done!"
    echo""
    for g in "${sssp_input_graphs[@]}"
    do
      gn=${g::-4}
      res_DIR=$benchmark_name"-INPUT-"$gn
      mkdir $res_DIR
      cd $res_DIR
      ./../capture_PCs_real.sh $benchmark_name $g
      cd ..
      #####TOP-down
      #TOP_DIR="Toplev-"$benchmark_name"-INPUT-"$gn
      #mkdir $TOP_DIR                                                                                 
      #cd $TOP_DIR
      #echo ""
      #echo ""
      #echo "Toplevel analysis sssp becnhmark  ..."
      #python3 $python_codes_path/bench_graph_name.py ../../../"CRONO-benchmarks-baseline-toplev-l3-output.txt" $benchmark_name $gn
      #~/pmu-tools/toplev.py --core S0-C0 -l3 -v --no-desc taskset -c 0 -o $benchmark_name"-INPUT-"$gn"-toplev-l3.txt"  -- ./../$benchmark_name 1 1  $input_graphs_path/$g
      #echo "-------"
      #python3 $python_codes_path/toplev_rfile.py $benchmark_name"-INPUT-"$gn"-toplev-l3.txt" ../../../"CRONO-benchmarks-baseline-toplev-l3-output.txt"
      #cd ..

    done
    len=${#sssp_N[@]}
    for (( i=0; i<$len; i++ ))
    do
      res_DIR=$benchmark_name"-INPUT-N"${sssp_N[$i]}"-DEG"${sssp_DEG[$i]}
      mkdir $res_DIR
      cd $res_DIR
      ./../capture_PCs_syn.sh $benchmark_name ${sssp_N[$i]} ${sssp_DEG[$i]}
      cd ..
      ####TOP-DOWN
      #TOP_DIR="Toplev-"$benchmark_name"-INPUT-N"${sssp_N[$i]}"-DEG"${sssp_DEG[$i]}
      #mkdir $TOP_DIR                                                                                 
      #cd $TOP_DIR
      #echo ""
      #echo ""
      #echo "Toplevel analysis for bfs becnhmark  ..."
      #python3 $python_codes_path/bench_graph_name.py ../../../"CRONO-benchmarks-baseline-toplev-l3-output.txt" $benchmark_name "N"${sssp_N[$i]}"-D"${sssp_DEG[$i]}
      #~/pmu-tools/toplev.py --core S0-C0 -l3 -v --no-desc taskset -c 0 -o $benchmark_name"-INPUT-N"${sssp_N[$i]}"-DEG"${sssp_DEG[$i]}"-toplev-l3.txt"  -- ./../$benchmark_name 0 1 ${sssp_N[$i]} ${sssp_DEG[$i]}
      #echo "-------"
      #python3 $python_codes_path/toplev_rfile.py $benchmark_name"-INPUT-N"${sssp_N[$i]}"-DEG"${sssp_DEG[$i]}"-toplev-l3.txt" ../../../"CRONO-benchmarks-baseline-toplev-l3-output.txt"
      #cd ..


    done
    cd ..

  fi

  if [[ "$benchmark_name" == "dfs" ]]
  then
    echo ""
    echo "Compile dfs becnhmark ..."
    bench_dir=$benchmark_name
    mkdir $bench_dir
    cd $bench_dir  
    $LLVM10_buildMyPasses/bin/clang++ -gmlt -std=c++11 -O3  -fdebug-info-for-profiling -Wall $benchmark_path/$benchmark_name/$benchmark_name".cc" -S -emit-llvm -o $benchmark_name".ll" 
    $LLVM10_buildMyPasses/bin/clang++ -gmlt -std=c++11 -O3  -fdebug-info-for-profiling -Wall  $benchmark_path/$benchmark_name/$benchmark_name".cc" -o $benchmark_name -lpthread -lrt
    cp $scripts_path/capture_PCs_real.sh .
    cp $scripts_path/capture_PCs_syn.sh .
    echo "done!"
    echo""
    for g in "${dfs_input_graphs[@]}"
    do
      gn=${g::-4}
      res_DIR=$benchmark_name"-INPUT-"$gn
      mkdir $res_DIR
      cd $res_DIR
      ./../capture_PCs_real.sh $benchmark_name $g
      cd ..
      ######TOP-DOWN
      #TOP_DIR="Toplev-"$benchmark_name"-INPUT-"$gn
      #mkdir $TOP_DIR                                                                                 
      #cd $TOP_DIR
      #echo ""
      #echo ""
      #echo "Toplevel analysis dfs becnhmark  ..."
      #python3 $python_codes_path/bench_graph_name.py ../../../"CRONO-benchmarks-baseline-toplev-l3-output.txt" $benchmark_name $gn
      #~/pmu-tools/toplev.py --core S0-C0 -l3 -v --no-desc taskset -c 0 -o $benchmark_name"-INPUT-"$gn"-toplev-l3.txt"  -- ./../$benchmark_name 1 1  $input_graphs_path/$g
      #echo "-------"
      #python3 $python_codes_path/toplev_rfile.py $benchmark_name"-INPUT-"$gn"-toplev-l3.txt" ../../../"CRONO-benchmarks-baseline-toplev-l3-output.txt"
      #cd ..

    done
    len=${#dfs_N[@]}
    for (( i=0; i<$len; i++ ))
    do
      res_DIR=$benchmark_name"-INPUT-N"${dfs_N[$i]}"-DEG"${dfs_DEG[$i]}
      mkdir $res_DIR
      cd $res_DIR
      ./../capture_PCs_syn.sh $benchmark_name ${dfs_N[$i]} ${dfs_DEG[$i]}
      cd ..
      ######TOP-DOWN
      #TOP_DIR="Toplev-"$benchmark_name"-INPUT-N"${dfs_N[$i]}"-DEG"${dfs_DEG[$i]}
      #mkdir $TOP_DIR                                                                                 
      #cd $TOP_DIR
      #echo ""
      #echo ""
      #echo "Toplevel analysis for bfs becnhmark  ..."
      #python3 $python_codes_path/bench_graph_name.py ../../../"CRONO-benchmarks-baseline-toplev-l3-output.txt" $benchmark_name "N"${dfs_N[$i]}"-D"${dfs_DEG[$i]}
      #~/pmu-tools/toplev.py --core S0-C0 -l3 -v --no-desc taskset -c 0 -o $benchmark_name"-INPUT-N"${dfs_N[$i]}"-DEG"${dfs_DEG[$i]}"-toplev-l3.txt"  -- ./../$benchmark_name 0 1 ${dfs_N[$i]} ${dfs_DEG[$i]}
      #echo "-------"
      #python3 $python_codes_path/toplev_rfile.py $benchmark_name"-INPUT-N"${dfs_N[$i]}"-DEG"${dfs_DEG[$i]}"-toplev-l3.txt" ../../../"CRONO-benchmarks-baseline-toplev-l3-output.txt"
      #cd ..
    done
    cd ..
  fi

done
  

