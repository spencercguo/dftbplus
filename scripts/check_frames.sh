#!/bin/bash

n=$1
for ((i=0; i<$n; i++)) do
    filepath="$SCRATCH/dftb-dft-dipoles/data/data-$i/"
    file=$(find $filepath -name "*.out")
    if [[ ! -n $file ]]
    then
        echo $i
    fi
done
