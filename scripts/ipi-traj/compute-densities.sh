#!/bin/bash

exe_dftb=dftb+

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

    # make waveplot file and run
    waveplot_in=$HOME/dipoles/dftb_inputs/waveplot_in.hsd
    cp \$waveplot_in .
    sed -i s:
    # compress cube data
    bqbtool compress voltraj wp-abs2.cube output.bqb
    rm -f wp-bas2.cube

    cd ../
    done" > $job_file

    sbatch $job_file
done


