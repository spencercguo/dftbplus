#!/bin/bash
#SBATCH -p hns
#SBATCH --job-name=travis
#SBATCH --output=travis-%A-%a.out
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=1GB
#SBATCH --time=03:30:00
#SBATCH --array=0-99
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=scguo@stanford.edu

echo 'started at ' `date`

input=$HOME/dipoles/scripts/ipi-traj/input.txt
for ((i=0; i<600; i+=2))
do
    index=$((SLURM_ARRAY_TASK_ID * 600 + i))
    data_folder=data-$index
    cd $SCRATCH/dftb-ipi/dftb/$data_folder
     
    travis -p output.bqb -i $input
done

echo 'finished at ' `date`
