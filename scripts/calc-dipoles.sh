#!/bin/bash

job_dir=$PWD/scripts/job_split-2
data_dir="${SCRATCH}/dftb-dft-dipoles/split"
path=$SCRATCH/dftb-dft-dipoles
script_path=$HOME/dipoles/python/calc-dipoles.py 
pdb=$HOME/dipoles/300K_water128_1.pdb

module load python/3.6.1
module load py-numpy/1.17.2_py36

echo "starting"

# xyz_file="${data_dir}/dft_traj-0.xyz"
for (( i=0; i < 1; i++ )); do
    xyz_file="$data_dir/dft_traj-${i}.xyz"
    job_file="${job_dir}/job-${i}.job"
    # echo $xyz_file

    echo "#!/bin/bash
#SBATCH --job-name=${i}.job
#SBATCH --output=${job_dir}/${i}.out
#SBATCH --time=00:01:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=scguo@stanford.edu 

srun python3 $script_path $xyz_file $pdb $path/data/data- ${i}000 $PWD/split_dipoles" > $job_file

    sbatch $job_file
done

echo "done"
