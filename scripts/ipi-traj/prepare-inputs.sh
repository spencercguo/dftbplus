#!/bin/bash
# #SBATCH --job-name=full-run-2
# #SBATCH --time=10:00:00
# #SBATCH --nodes=2
# #SBATCH --cpus-per-task=2
# #SBATCH --ntasks=20
# #SBATCH --mail-type=FAIL,END
# #SBATCH --mail-user=scguo@stanford.edu

echo 'started at ' `date`
echo 'hostname: ' `hostname`

# setup
ml python/3.6.1
ml py-numpy/1.17.2_py36

# number of total frames to run
n=10000

cd $HOME/dipoles/scripts/ipi-traj/

# ipi files
ipi_dir=$SCRATCH/dftb-ipi

# split trajectory file
echo 'splitting trajectory file'
traj_file=$ipi_dir/data/run.positions.xyz
split_script=$HOME/dipoles/python/split_traj.py
split_header=$ipi_dir/split/ipi-traj-

echo 'finished splitting'

# convert all files to .gen
input_files='$SCRATCH/dftb-dft-dipoles/input_files'
lattice='/home/users/scguo/dipoles/lattice.xyz'
convert_script='/home/users/scguo/dipoles/xyz2gen.py'
output=$ipi_dir/dftb/data-

echo 'started making input files at ' `date`

for ((i=0; i < $(( n / 20)); i++)) do
    for ((j=0; j < 20; j++)) do
        index=$((i * 20 + j))
        out=${output}${index}/${index}.gen
        touch $out
        mkdir $output$index
        python $convert_script -l ${lattice} -o ${output}${index}/${index}.gen ${split_header}${index}.xyz &
    done
    wait
done

wait

echo 'finished making input files at ' `date`

# wait for everyone to finish and terminate
wait
echo '    finished at:' `date`

