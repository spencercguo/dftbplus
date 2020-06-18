#!/bin/bash
#SBATCH --job-name=prep-inp
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=20
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=scguo@stanford.edu

echo 'started at ' `date`
echo 'hostname: ' `hostname`

# setup
ml python/3.6.1
ml py-numpy/1.17.2_py36

# number of total frames to run
n=60000

cd $HOME/dipoles/scripts/ipi-traj/

# ipi files
ipi_dir=$SCRATCH/dftb-ipi

# split trajectory file
echo 'splitting trajectory file'
traj_file=$ipi_dir/data/run.positions_0.xyz
split_script=$HOME/dipoles/python/split_traj.py
split_header=dftb-ipi/split/
python3 $split_script $traj_file 1 $n $split_header ipi-traj

echo 'finished splitting'

# convert all files to .gen
input_files=$SCRATCH/dftb-dft-dipoles/input_files
lattice=$HOME/dipoles/lattice.xyz
convert_script=$HOME/dipoles/xyz2gen.py
output=$ipi_dir/gen_files/data-

ml py-numpy/1.14.3_py27

echo 'started making input files at ' `date`

for ((i=0; i < $(( n / 20)); i++)) do
    for ((j=0; j < 20; j++)) do
        index=$((i * 20 + j))
        in=$SCRATCH/${split_header}ipi-traj-${index}.xyz
        out=${output}${index}/${index}.gen
        mkdir $output$index
        touch $out
        python $convert_script -l ${lattice} -o $out $in &
    done
    wait
done

wait

echo 'finished making input files at ' `date`

# wait for everyone to finish and terminate
wait
echo '    finished at:' `date`

