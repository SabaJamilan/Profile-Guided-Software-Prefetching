# Profile-Guided-Software-Prefetching
## Description
APT-GET is a novel profile-guided technique that ensures prefetch timeliness by leveraging dynamic execution time information. In this page, we provide the profile guided software prefetching LLVM pass code for indirect memory access patterns that is designed for APT-GET. You can also find scripts and python codes that you need to run the experiments. 
## Instructions
How to run APT-GET (as an example for CRONO benchmarks)
1) First you need to clone the APT-GET git-repository.
2) You should create a "results" folder besides the other folders.
3) You need to set the required PATHs in "run-CRONO-benchmarks.sh".
4) You can get CRONO benchmark suite fro "https://github.com/masabahmad/CRONO" and set the path to its "app" folder.
5) You can get the input graphs from SNAP website: "http://snap.stanford.edu/data/web-Google.html". (You can get the other benchmarks in the paper from "https://github.com/SamAinsworth/reproduce-cgo2017-paper/tree/master/program".)
7) run "./scripts/run-CRONO-benchmarks.sh".
## APT-GET Paper link
Here is the link to the paper: https://dl.acm.org/doi/abs/10.1145/3492321.3519583
