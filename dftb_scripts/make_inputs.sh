#!/bin/bash

# split files into individual frames
n=100000
python split_traj.py $n

header="dft_traj-"

# convert all files to .gen
module load py-numpy
mkdir input_files
cd input_files

for ((i=0; i < $n; i++)) do
    echo writing $header$i".gen"
    python ../xyz2gen.py -l ../lattice.xyz $header$i".xyz"
    wait
    rm -f $header$i".xyz"
done

cd ../
