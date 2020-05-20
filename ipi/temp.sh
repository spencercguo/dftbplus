#PBS -S /bin/sh
#PBS -q intel_16
#PBS -l nodes=1:ppn=16
#PBS -V
#PBS -j oe
#PBS -m ea
#PBS -M misch@stanford.edu

cd $PBS_O_WORKDIR

# setup
source /home/misch/programs/cp2k-4.1-openmpi/tools/toolchain/install/setup
source /home/misch/programs/i-pi-dev/env.sh

# print some information
echo '     started at:' `date`
echo '       hostname:' `hostname`

# run i-PI and wait a while
rm -f /tmp/ipi*
sleep 5
i-pi input.xml > IMI.log &
sleep 5

# DFTB executable
exe_dftb=/home/misch/programs/dftbplus-18.2/_install/bin/dftb+

# run DFTB+
cd DFTB
mpirun -np 16 $exe_dftb > IMI.log &
cd ../

# wait for everyone to finish and terminate
wait
echo '    finished at:' `date`

