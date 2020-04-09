#!/bin/bash

for ((i=0; i < 7; i++)) do
        echo "
    # setup environment
    module load imkl/2017.u2
    module load impi/2017.u2
    module load icc/2017.u2

    # DFTB executable
    exe_dftb=dftb+

    # 20 cores, 20 tasks, 1 core per task
    np=1

    # run DFTB+
    # nframes=10

    # mkdir data
    cd $SCRATCH/dftb-dft-dipoles/data

    # run dftb+ static calculation on each frame
    for ((i=0; i < $((n / 20)); i++)) do
        for ((j=0; j < 20; j++)) do
            index=$((i * 20 + j))

            # folder for frame data
            data_folder="data-$index"
            
            # input template file
            dftb_in=$HOME/dipoles/dftb_inputs/dftb_in.hsd
            cp $dftb_in $data_folder

            # DFTB must be run from the input file folder
            cd $data_folder

            # change dftb+ input file
            sed -i "s:example:$SCRATCH/dftb-dft-dipoles/data/${data_folder}/${index}:" dftb_in.hsd

            log_file="${index}.log"
            touch $log_file

            srun -n $np $exe_dftb > $log_file & 
            cd ../
        done
        wait
    done

# wait for everyone to finish and terminate
wait
echo '    finished at:' `date`
    "

