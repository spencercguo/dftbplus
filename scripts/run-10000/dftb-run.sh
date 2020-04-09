#!/bin/bash
# #SBATCH --job-name=full-run-2
# #SBATCH --time=10:00:00
# #SBATCH --nodes=2
# #SBATCH --cpus-per-task=2
# #SBATCH --ntasks=20
# #SBATCH --mail-type=FAIL,END
# #SBATCH --mail-user=scguo@stanford.edu

echo 'started at ' `date`
echo 'hostname: ' `hostname`

# number of total frames to run
n=10000

header="$SCRATCH/dftb-dft-dipoles/split-2/dft_traj-"
output="$SCRATCH/dftb-dft-dipoles/data/data-"

# convert all files to .gen
# ml python
# ml py-numpy
# 
# input_files='$SCRATCH/dftb-dft-dipoles/input_files'
# 
# lattice='/home/users/scguo/dipoles/lattice.xyz'
# script_path='/home/users/scguo/dipoles/xyz2gen.py'
# 
# for ((i=0; i < $(( n / 20)); i++)) do
#     for ((j=0; j < 20; j++)) do
#         index=$((i * 20 + j))
#         out=${output}${index}/${index}.gen
#         touch $out
#         # echo writing $out
#         python $script_path -l ${lattice} -o ${output}${index}/${index}.gen ${header}${index}.xyz &
#     done
#     wait
# done
# 
# wait
# 
# echo 'finished making input files at ' `date`

######################
# DFTB Calculations
######################

# setup environment
module load imkl/2017.u2
module load impi/2017.u2
module load icc/2017.u2

# DFTB executable
exe_dftb=dftb+

# 20 cores, 20 tasks, core per task
np=2

# run DFTB+
# nframes=10

# mkdir data
cd $SCRATCH/dftb-dft-dipoles/data

start_frame=5000

# run dftb+ static calculation on each frame
# break up into jobs of 20 frames each
for ((i=$((start_frame / 20)); i < $((n / 20)); i++)) do
    job_file=$HOME/dipoles/scripts/run-10000/${i}.job
    index_string='$((i2 * 20 + j))'

    echo "#!/bin/bash
#SBATCH --job-name=full-run-$i
#SBATCH --time=00:10:00
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=$USER@stanford.edu

echo 'started at ' `date`

header=$SCRATCH/dftb-dft-dipoles/split-2/dft_traj-
output=$SCRATCH/dftb-dft-dipoles/data/data-

module load imkl/2017.u2
module load impi/2017.u2
module load icc/2017.u2

exe_dftb=dftb+
np=4
cd $SCRATCH/dftb-dft-dipoles/data

for ((j=0; j < 20; j++)) do
    i2=$i
    index=$index_string
    # folder for frame data
    data_folder=data-\$index
    
    # input template file
    dftb_in=$HOME/dipoles/dftb_inputs/dftb_in.hsd
    cp \$dftb_in \$data_folder

    # DFTB must be run from the input file folder
    cd \$data_folder

    # change dftb+ input file
    sed -i s:example:$SCRATCH/dftb-dft-dipoles/data/\${data_folder}/\${index}: dftb_in.hsd

    log_file=\${index}.log
    touch \$log_file

    srun -n \$np \$exe_dftb > \$log_file
    cd ../
    done" > $job_file
sbatch $job_file
done

# wait for everyone to finish and terminate
wait
echo '    finished at:' `date`


