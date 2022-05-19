#!/bin/bash 
benchmark_name=$1
g=$2
prefetch_distance=(4 8 16 32 64)
####################PATHs
benchmark_path=""                     
results_path=""
input_graphs_path=""
python_codes_path=""
LLVM10_buildMyPasses=""


echo ""
echo "benchmark_name:   "$benchmark_name
echo "input-graph:      "$g  
echo "################################## LLC misses"
echo "Capture deliquent load PCs ... "

gn=${g::-4}
####################LLC misses
LLC_DIR="LLC-misses-"$benchmark_name"-INPUT-"$gn
mkdir $LLC_DIR
cd $LLC_DIR 
echo ""
echo "  1) perf record LLC misses ...."
perf record -e cpu/event=0xd1,umask=0x20,name=MEM_LOAD_RETIRED.L3_MISS/ppp -- ./../../$benchmark_name 1 1 $input_graphs_path/$g
echo ""
echo "  2) perf report --stdio ...."
perf report --stdio > $benchmark_name"-INPUT-"$gn"-perfReport.txt"
echo ""
echo "  3) Capture Functions that cause  most LLC misses ..."
python3 $python_codes_path/read-func.py $benchmark_name"-INPUT-"$gn"-perfReport.txt" $benchmark_name"-INPUT-"$gn"-FuncPercentList.txt" $benchmark_name"-INPUT-"$gn"-FuncList.txt" $benchmark_name
echo ""
echo "  4) perf annotate --stdio  &  Capturing all deliquent load PCs for each function ...."
while read FUNC; do
  echo "       Function Name:    $FUNC"
  perf annotate --stdio -M intel "$FUNC" > $benchmark_name"-INPUT-"$gn"-"$FUNC".txt"
  sed -i '1d' $benchmark_name"-INPUT-"$gn"-"$FUNC".txt"
  python3 $python_codes_path/llc_missed_pcs_rfile.py $benchmark_name"-INPUT-"$gn"-"$FUNC".txt" $benchmark_name"-INPUT-"$gn"-"$FUNC"-PCPersentList.txt" $benchmark_name"-INPUT-"$gn"-"$FUNC"-PCList.txt"
  cat $benchmark_name"-INPUT-"$gn"-"$FUNC"-PCList.txt" >> $benchmark_name"-INPUT-"$gn"-ALL-PCList.txt"
  #echo "       done for Function:   $FUNC"
done < $benchmark_name"-INPUT-"$gn"-FuncList.txt"
#echo "done!"
echo ""


echo "############################# LBR sampling"


if [[ "$benchmark_name" == "bc" ]]
then
  timeout 10s perf record -e cycles:u -j any,u -o perf.data -- ./../../$benchmark_name 1 1 $input_graphs_path/$g
else
  timeout 10s perf record -e cycles:u -j any,u -o perf.data -- ./../../$benchmark_name 1 1 $input_graphs_path/$g
fi
time perf script -F ip,brstack -i perf.data  > "dump-"$benchmark_name"-INPUT-"$gn"-whole-app-LBRsamples-brstack.txt"
perf script -F ip,brstack,brstackinsn -i perf.data  > "dump-"$benchmark_name"-INPUT-"$gn"-whole-app-LBRsamples-brstackinsn.txt"

while read PC; do
  python3 $python_codes_path/first_filter_samples.py "dump-"$benchmark_name"-INPUT-"$gn"-whole-app-LBRsamples-brstackinsn.txt" $PC 
done <  $benchmark_name"-INPUT-"$gn"-ALL-PCList.txt"

while read PC; do
  python3 $python_codes_path/find_src_in_branches.py "first-filter-"$PC".txt" $PC 
  while read PC_src; do
    python3 $python_codes_path/find_dest_in_branches.py "first-filter-"$PC".txt" $PC_src $PC 
  done < "in-branches-src-PC-"$PC".txt" 
done <  $benchmark_name"-INPUT-"$gn"-ALL-PCList.txt"
######




while read PC; do
  src="$(sed "1q;d" "in-branches-src-PC-"$PC".txt")"
  dst="$(sed "1q;d" "in-branches-dest-PC-"$PC".txt")"
  echo "PC: " $PC
  echo "   src: " $src
  echo "   dst: " $dst

  python3 $python_codes_path/filter_samples.py "dump-"$benchmark_name"-INPUT-"$gn"-whole-app-LBRsamples-brstackinsn.txt" $PC 
  
  python3 $python_codes_path/temp.py "dump-"$benchmark_name"-INPUT-"$gn"-whole-app-LBRsamples-brstack.txt" "0x"$src "0x"$dst $PC 
  
  python3 $python_codes_path/dist-between-2-occur-outerloop.py  "dump-"$benchmark_name"-INPUT-"$gn"-whole-app-LBRsamples-brstack.txt" "0x"$src "0x"$dst $PC  python3 $python_codes_path/dist-between-2-occur-outerloop.py  "filter-"$PC".txt" "0x"$src "0x"$dst $PC
  tail -n 5000 "0x"$src"-0x"$dst"-dist-between-2-occur-outerloop-PC-"$PC".txt" > "x.txt"
  
  python3 $python_codes_path/cal-avg-dist-outerloop.py "0x"$src"-0x"$dst"-dist-between-2-occur-outerloop-PC-"$PC".txt" "0x"$src "0x"$dst $PC
  python3 $python_codes_path/cal-avg-dist-outerloop.py "x.txt" "0x"$src "0x"$dst $PC 
  
  val="$(sed "2q;d" "0x"$src"-0x"$dst"-avg-dist-outerloop-PC-"$PC".txt")"
  python3 $python_codes_path/inner-iters.py  "dump-"$benchmark_name"-INPUT-"$gn"-whole-app-LBRsamples-brstack.txt" "0x"$src "0x"$dst $PC
  python3 $python_codes_path/cal-avg-inner-iters.py "0x"$src"-0x"$dst"-innet-iters-PC-"$PC".txt" "0x"$src "0x"$dst $PC  
  python3 $python_codes_path/inner-avg-iter-time.py  "dump-"$benchmark_name"-INPUT-"$gn"-whole-app-LBRsamples-brstack.txt" "0x"$src "0x"$dst $PC 
  python3 $python_codes_path/cal-avg-inner-iter-time.py "0x"$src"-0x"$dst"-avg-inner-iter-time-PC-"$PC".txt" "0x"$src "0x"$dst $PC  
  python3 $python_codes_path/plot-scatter.py "0x"$src"-0x"$dst"-cycles-PC-"$PC"-new.txt" "0x"$src"-0x"$dst"-cycles-PC-"$PC"-new-plot"  
  python3 $python_codes_path/test-plot.py "0x"$src"-0x"$dst"-cycles-PC-"$PC"-new.txt" "0x"$src"-0x"$dst"-cycles-PC-"$PC 
  python3 $python_codes_path/sort-data.py "0x"$src"-0x"$dst"-cycles-PC-"$PC"-test-plot.csv" "0x"$src"-0x"$dst"-cycles-PC-"$PC 
  python3 $python_codes_path/find-peaks.py "0x"$src"-0x"$dst"-cycles-PC-"$PC"-sorted-data.csv" "0x"$src"-0x"$dst"-cycles-PC-"$PC   
  first_peak="$(sed "1q;d" "0x"$src"-0x"$dst"-cycles-PC-"$PC"-peaks.csv")"
  sec_peak="$(sed "2q;d" "0x"$src"-0x"$dst"-cycles-PC-"$PC"-peaks.csv")"
  three_peak="$(sed "3q;d" "0x"$src"-0x"$dst"-cycles-PC-"$PC"-peaks.csv")"
  four_peak="$(sed "4q;d" "0x"$src"-0x"$dst"-cycles-PC-"$PC"-peaks.csv")"
  val_r=`echo $val | awk '{print int($1)}'`
  INT=200
  if (( $val_r > $INT ));then
    dist=$(python3 $python_codes_path/calculate-dist.py "0x"$src"-0x"$dst"-cycles-PC-"$PC"-new.txt" $PC $first_peak $four_peak $benchmark_name"-INPUT-"$gn)
  else
    dist=$(python3 $python_codes_path/calculate-dist-crono.py "0x"$src"-0x"$dst"-cycles-PC-"$PC"-new.txt" $PC $first_peak $four_peak $benchmark_name"-INPUT-"$gn)
  fi
done < $benchmark_name"-INPUT-"$gn"-ALL-PCList.txt"

cp $benchmark_name"-INPUT-"$gn"-ALL-dist2.csv" ../
cp $benchmark_name"-INPUT-"$gn"-ALL-dist1.csv" ../
cd ../


echo "#############################Perf Stats for Baseline config"
STATS_DIR="Perf-Stats-"$benchmark_name"-INPUT-"$gn
mkdir $STATS_DIR
cd $STATS_DIR

python3 $python_codes_path/bench_name.py ../../../../"CRONO-benchmarks-perf-stats-output.txt" $benchmark_name
perf stat -o $benchmark_name"-INPUT-"$gn"-perf-stats.out" -e L1-dcache-loads -e L1-dcache-load-misses -e L2-loads -e L2-load-misses -e LLC-loads -e LLC-load-misses -e cycles -e instructions -e SW_PREFETCH_ACCESS.T1_T2 -e SW_PREFETCH_ACCESS.T0 -e SW_PREFETCH_ACCESS.NTA -e LOAD_HIT_PRE.SW_PF -e cache-misses ./../../$benchmark_name 1 1 $input_graphs_path/$g

echo "" >>  $benchmark_name"-INPUT-"$gn"-perf-stats.out"
echo "Config: Baseline">> $benchmark_name"-INPUT-"$gn"-perf-stats.out"
echo "    Input_graph = " $g>> $benchmark_name"-INPUT-"$gn"-perf-stats.out"
echo "---------------------------------" >> $benchmark_name"-INPUT-"$gn"-perf-stats.out"
echo ""
python3 $python_codes_path/perf_rfile_baseline.py $benchmark_name"-INPUT-"$gn"-perf-stats.out" ../../../../"CRONO-benchmarks-perf-stats-output.txt"
cp ../../$benchmark_name .
cp ../../$benchmark_name".ll" .
echo ""
echo ""


<<com
echo "Getting perf stats for Prefetching configuration ...."
for dist in "${prefetch_distance[@]}"

do
  echo "prefetch-distance: "$dist
  if (( $val_r < $INT ));then
    dist=$( expr 1000 '*' "$dist")
  else
    echo ""
  fi
  echo "prefetch-distance: "$dist
  python3 $python_codes_path/mod_pc_dist_list.py ../$LLC_DIR/$benchmark_name"-INPUT-"$gn"-ALL-PCList.txt" $benchmark_name"-INPUT-"$gn"-ALL-PCList-Plus-dist"$dist".csv" $dist
  $AutoFDO10//create_llvm_prof --binary=$benchmark_name --profile=$benchmark_name"-INPUT-"$gn"-ALL-PCList-Plus-dist"$dist".csv" --profiler="prefetch" --format=text --out=$benchmark_name"-INPUT-"$gn"-dist"$dist"-prefetch.afdo"
  $LLVM10_buildMyPasses/bin/opt -load /soe/sjamilan/LLVM10/llvm-project-10.0.0/build_mypasses/lib/SWPrefetchingLLVMPass.so -S -SWPrefetchingLLVMPass -input-file $benchmark_name"-INPUT-"$gn"-dist"$dist"-prefetch.afdo" -dist $dist <$benchmark_name".ll"> $benchmark_name"-pref-INPUT-"$gn"-dist"$dist".ll"
  $LLVM10_buildMyPasses/bin/clang++ -gmlt -std=c++11 -O3  -fdebug-info-for-profiling  -Wall  $benchmark_name"-pref-INPUT-"$gn"-dist"$dist".ll" -c
  $LLVM10_buildMyPasses/bin/clang++ -gmlt -std=c++11 -O3  -fdebug-info-for-profiling -Wall  $benchmark_name"-pref-INPUT-"$gn"-dist"$dist".o" -o $benchmark_name"-pref-INPUT-"$gn"-dist"$dist -lpthread -lrt
  python3 $python_codes_path/bench_name.py ../../../../"CRONO-benchmarks-perf-stats-output.txt" $benchmark_name
  perf stat -o $benchmark_name"-pref-INPUT-"$gn"-dist"$dist"-perf-stats.out" -e L1-dcache-loads -e L1-dcache-load-misses -e L2-loads -e L2-load-misses -e LLC-loads -e LLC-load-misses -e cycles -e instructions -e SW_PREFETCH_ACCESS.T1_T2 -e SW_PREFETCH_ACCESS.T0 -e SW_PREFETCH_ACCESS.NTA -e LOAD_HIT_PRE.SW_PF -e cache-misses ./$benchmark_name"-pref-INPUT-"$gn"-dist"$dist 1 1 $input_graphs_path/$g
  echo "" >>  $benchmark_name"-pref-INPUT-"$gn"-dist"$dist"-perf-stats.out" 
  echo "Config: Prefetching">> $benchmark_name"-pref-INPUT-"$gn"-dist"$dist"-perf-stats.out"
  echo "    Input_graph = " $g>> $benchmark_name"-pref-INPUT-"$gn"-dist"$dist"-perf-stats.out"
  echo "    prefetch-distance = " $dist>> $benchmark_name"-pref-INPUT-"$gn"-dist"$dist"-perf-stats.out"
  echo "---------------------------------" >> $benchmark_name"-pref-INPUT-"$gn"-dist"$dist"-perf-stats.out"
  echo ""
  python3 $python_codes_path/perf_rfile_pref.py $benchmark_name"-pref-INPUT-"$gn"-dist"$dist"-perf-stats.out" ../../../../"CRONO-benchmarks-perf-stats-output.txt"
done


com
echo "#############################Perf stats for Prefetching with LBR prefetch distance"
cp ../$benchmark_name"-INPUT-"$gn"-ALL-dist2.csv" .
echo "prefetch-distance: "$dist
$AutoFDO10//create_llvm_prof --binary=$benchmark_name --profile=$benchmark_name"-INPUT-"$gn"-ALL-dist2.csv" --profiler="prefetch" --format=text --out=$benchmark_name"-INPUT-"$gn"-prefetch.afdo"
$LLVM10_buildMyPasses/bin/opt -load /soe/sjamilan/LLVM10/llvm-project-10.0.0/build_mypasses/lib/SWPrefetchingLLVMPass.so -S -SWPrefetchingLLVMPass -input-file $benchmark_name"-INPUT-"$gn"-prefetch.afdo" -dist $dist  <$benchmark_name".ll"> $benchmark_name"-pref-INPUT-"$gn".ll"
$LLVM10_buildMyPasses/bin/clang  --std=c++0x -O3  -fdebug-info-for-profiling  -Wall -Werror   $benchmark_name"-pref-INPUT-"$gn".ll" -c
$LLVM10_buildMyPasses/bin/clang -g --std=c++0x -O3  -fdebug-info-for-profiling -Wall -Werror  $benchmark_name"-pref-INPUT-"$gn".o" -o $benchmark_name"-pref-INPUT-"$gn -lpthread -lrt
python3 $python_codes_path/bench_name.py ../../../../"CGO17-benchmarks-perf-stats-output.txt" $benchmark_name

if [[ "$benchmark_name" == "bc" ]]
then
  perf stat -o $benchmark_name"-pref-INPUT-"$gn"-perf-stats.out" -e L1-dcache-loads -e L1-dcache-load-misses -e L2-loads -e L2-load-misses -e LLC-loads -e LLC-load-misses -e cycles -e instructions -e SW_PREFETCH_ACCESS.T1_T2 -e SW_PREFETCH_ACCESS.T0 -e SW_PREFETCH_ACCESS.NTA -e LOAD_HIT_PRE.SW_PF -e cache-misses ./$benchmark_name"-pref-INPUT-"$gn 1 1 $input_graphs_path/$g
else
  perf stat -o $benchmark_name"-pref-INPUT-"$gn"-perf-stats.out" -e L1-dcache-loads -e L1-dcache-load-misses -e L2-loads -e L2-load-misses -e LLC-loads -e LLC-load-misses -e cycles -e instructions -e SW_PREFETCH_ACCESS.T1_T2 -e SW_PREFETCH_ACCESS.T0 -e SW_PREFETCH_ACCESS.NTA -e LOAD_HIT_PRE.SW_PF -e cache-misses ./$benchmark_name"-pref-INPUT-"$gn 1 1 $input_graphs_path/$g

fi
echo "" >>  $benchmark_name"-pref-INPUT-"$gn"-perf-stats.out" 
echo "Config: Prefetching">> $benchmark_name"-pref-INPUT-"$gn"-perf-stats.out"
echo "    Input_graph = " $g>> $benchmark_name"-pref-INPUT-"$gn"-perf-stats.out"
echo "    prefetch-distance = "$dist>> $benchmark_name"-pref-INPUT-"$gn"-perf-stats.out"
echo "---------------------------------" >> $benchmark_name"-pref-INPUT-"$gn"-perf-stats.out"
echo ""
python3 $python_codes_path/perf_rfile_pref.py $benchmark_name"-pref-INPUT-"$gn"-perf-stats.out" ../../../../"CRONO-benchmarks-perf-stats-output.txt"





