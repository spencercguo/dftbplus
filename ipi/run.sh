#!/bin/bash
#SBATCH --job-name=dftb-ipi
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mail-type=START,FAIL,END
#SBATCH --mail-user=scguo@stanford.edu

cd $SCRATCH/dftb-ipi

# number of cores to use
np=16

# setup environment
module load imkl
module load ifort
module load impi
module load icc
module load python
module load py-numpy

# print some information
echo '     started at:' `date`
echo '       hostname:' `hostname`

rm -f data/*out*
rm -f data/*xyz
rm -f RESTART

# DFTB executable
exe_dftb=dftb+

# run i-PI and wait a while
rm -f /tmp/ipi*
sleep 5
i-pi input.xml > output/ipi.log &
sleep 5

# run DFTB+
cd DFTB

rm -f charges.bin
rm -f detailed.out
rm -f dftb_pin.hsd
rm -f dftb.log

srun -n 16 $exe_dftb > dftb.log &
cd ../

# wait for everyone to finish and terminate
wait
echo '    finished at:' `date`

