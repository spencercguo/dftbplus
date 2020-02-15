#!/bin/bash
#SBATCH --job-name=dftb-dipole-80000
#SBATCH --time=04:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=20
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=scguo@stanford.edu

# number of cores to use
np=20

# setup environment
module load imkl/2017.u2
module load impi/2017.u2
module load icc/2017.u2
module load python
module load py-numpy

# print some information
echo '     started at:' `date`
echo '       hostname:' `hostname`

# DFTB executable
exe_dftb=dftb+

# run DFTB+
nframes=10

# mkdir data
cd data

# run dftb+ static calculation on each frame
for ((i=97000; i < 98000; i++)) do
  # make folder for frame data
  new_folder="data-$i"
  mkdir $new_folder
  cp dftb_in.hsd $new_folder
  cd $new_folder

  # change dftb+ input file
  sed -i "s:example:/scratch/users/scguo/dftb-dft-dipoles/input_files/dft_traj-$i:" dftb_in.hsd
  log_file="out-frame-$i.log"
  # echo $log_file
  touch $log_file
  srun -n $np $exe_dftb > $log_file
  cd ../
done

cd ../

# wait for everyone to finish and terminate
wait
echo '    finished at:' `date`

