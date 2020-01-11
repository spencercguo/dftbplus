#!/bin/bash
#SBATCH --job-name=read-dipoles
#SBATCH --output=calc-dipoles.out
#SBATCH --time=00:10:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=16G
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=scguo@stanford.edu

# import modules
module load python/3.6.1
module load py-numpy/1.17.2_py36

# print some information
echo '     started at:' `date`
echo '       hostname:' `hostname`

path=$SCRATCH/dftb-dft-dipoles
srun python3 calc_dipoles.py $path/dft_traj.xyz $path/input_topology.pdb $path/data/data- > calc_dipoles.log

# wait for everyone to finish and terminate
wait
echo '    finished at:' `date`

