#!/bin/bash
#SBATCH --job-name=calc-dipoles
#SBATCH --output=calc-dipoles.out
#SBATCH --time=00:01:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=scguo@stanford.edu 
# import modules
module load python/3.6.1
module load py-numpy/1.17.2_py36

# print some information
echo '     started at:' `date`
echo '       hostname:' `hostname`

path=$SCRATCH/dftb-dft-dipoles
# pwd
srun python3 ~/dipoles/calc-dipoles.py $path/dft_traj.xyz $path/input_topology.pdb $path/data/data- > ~/dipoles/calc-dipoles.log

# wait for everyone to finish and terminate
echo '    finished at:' `date`

