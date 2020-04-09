#!/bin/bash

# split files into individual frames
n=10000
# python split_traj.py $n

header="/scratch/users/dftb-dft-dipoles/dft_traj-"

# convert all files to .gen
module load py-numpy
# mkdir input_files
# cd input_files
input_files=$SCRATCH/'dftb-dft-dipoles/input_files'

# script_dir='/home/users/scguo/scripts'
script_path='/home/users/scguo/dipoles/xyz_to_gen.py'

for ((i=0; i < $n; i++)) do
    echo writing $header$i".gen"
    python ../xyz2gen.py -l ../lattice.xyz $header$i".xyz"
    wait
    rm -f $header$i".xyz"
done

cd ../
