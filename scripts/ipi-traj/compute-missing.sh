#!/bin/bash
#SBATCH -p hns
#SBATCH --job-name=array_missing
#SBATCH --output=missing-%A-%a.out
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=16GB
#SBATCH --time=01:30:00
#SBATCH --array=1-100:10
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=scguo@stanford.edu

echo 'started at ' `date`

module load imkl/2017.u2
module load impi/2017.u2
module load icc/2017.u2

exe_dftb=dftb+
np=4

# ./check_frames.sh 0 60000 > missing.txt
missing=$HOME/dipoles/scripts/ipi-traj/missing.txt

for ((j=0; j<10; j++)) do 
    i=$((SLURM_ARRAY_TASK_ID + j))
    echo $i
    index=$(sed "${i}q;d" $missing)
    echo $index
    # folder for frame data
    data_folder=data-$index

    cd $SCRATCH/dftb-ipi/dftb/$data_folder
    
    if [[ ! -n $(find . -name *.bin) ]]
    then
        dftb_in=$HOME/dipoles/scripts/ipi-traj/dftb_template.hsd
        cp $dftb_in dftb_in.hsd

        # change dftb+ input file
        sed -i s:XXXINPUT01:${index}: dftb_in.hsd

        log_file=${index}.log
        touch $log_file

        srun $exe_dftb > $log_file
    fi

    # run waveplot to get cube file
    waveplot_in=$HOME/dipoles/scripts/ipi-traj/waveplot_template.hsd
    cp -f $waveplot_in waveplot_in.hsd
    srun waveplot > waveplot.out

    # compress cube data
    rm -f output.bqb
    bqbtool compress voltraj wp-abs2.cube output.bqb
    rm -f wp-abs2.cube
done

echo 'ended at ' `date`
