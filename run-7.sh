#!/bin/bash
#SBATCH --job-name=dftb-dipoles
#SBATCH --time=00:10:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=scguo@stanford.edu

# number of cores to use
np=4

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


# mkdir data
cd data

# run dftb+ static calculation on each frame
for p in $(cat /scratch/users/scguo/dftb-dft-dipoles/missing_frames.txt); do
  folder="data-$p"
  echo "    calculations for frame $p"
  cd $folder

  log_file="out-frame-$p.log"
  # echo $log_file
  srun -n $np $exe_dftb > $log_file
#   wait
  cd ../
done # < /scratch/users/scguo/dftb-dft-dipoles/missing_frames.txt

cd ../

# wait for everyone to finish and terminate
wait
echo '    finished at:' `date`

