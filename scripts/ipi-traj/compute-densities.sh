#!/bin/bash

cd $HOME/dipoles/scripts/ipi-traj

start_frame=19940
n=60000

# run dftb+ static calculation on each frame
# break up into jobs of 20 frames each
for ((i=0; i < $((n / 20)); i++)) do
    job_file="jobs"/${i}.sbatch
    index_string='$((i2 * 20 + j))'

    echo "#!/bin/bash
#SBATCH --job-name=dens-$i
#SBATCH --output=${i}.out
#SBATCH --time=03:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=$USER@stanford.edu

echo 'started at ' \`date\`

module load imkl/2017.u2
module load impi/2017.u2
module load icc/2017.u2

exe_dftb=dftb+
np=4
cd $SCRATCH/dftb-ipi/dftb

for ((j=0; j < 20; j++)) do
    i2=$i
    index=$index_string
    # folder for frame data
    data_folder=data-\$index
    
    # input template file
    dftb_in=$HOME/dipoles/scripts/ipi-traj/dftb_template.hsd
    cp \$dftb_in \$data_folder/dftb_in.hsd

    # DFTB must be run from the input file folder
    cd \$data_folder

    # change dftb+ input file
    sed -i s:XXXINPUT01:\${index}: dftb_in.hsd

    log_file=\${index}.log
    touch \$log_file

    srun -c \$np \$exe_dftb > \$log_file

    # make waveplot file and run
    waveplot_in=$HOME/dipoles/scripts/ipi-traj/waveplot_template.hsd
    cp -f \$waveplot_in waveplot_in.hsd
    srun waveplot > waveplot.out

    # compress cube data
    rm -f output.bqb
    bqbtool compress voltraj wp-abs2.cube output.bqb
    rm -f wp-abs2.cube

    cd ../
done" > $job_file

    sbatch $job_file
done


