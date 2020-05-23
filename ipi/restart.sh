#!/bin/bash
#SBATCH --job-name=dftb-ipi-2
#SBATCH --time=16:00:00
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

# DFTB executable
exe_dftb=dftb+

rm -f EXIT
rm -f DFTB/charges.bin
rm -f DFTB/detailed.out
rm -f DFTB/dftb_pin.hsd

# run i-PI and wait a while
rm -f /tmp/ipi*
sleep 5
i-pi RESTART >> output/ipi.log &
sleep 5

# run DFTB+
cd DFTB

srun -n 16 $exe_dftb >> dftb.log &
cd ../

# wait for everyone to finish and terminate
sleep 15.9h
touch EXIT
sleep 10
echo '    finished at:' `date`

