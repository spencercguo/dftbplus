#!/bin/bash
#SBATCH --job-name=dftb-ipi
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

rm -f data/run*
# rm -f data/*xyz
# rm -f RESTART

rm -f DFTB/charges.bin
rm -f DFTB/detailed.out
rm -f DFTB/dftb_pin.hsd
rm -f DFTB/dftb.log

# DFTB executable
exe_dftb=dftb+

# run i-PI and wait a while
rm -f /tmp/ipi*
sleep 5
i-pi input.xml > output/ipi.log &
sleep 5

# run DFTB+
cd DFTB
srun -n $np $exe_dftb > dftb.log &
cd ../

# wait for until end of job period
sleep 15.9h
touch EXIT
sleep 10
echo '    finished at:' `date`

