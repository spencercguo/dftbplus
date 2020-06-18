#!/bin/bash

n=$1
for ((i=0; i<$n; i++)) do
    filepath="$SCRATCH/dftb-ipi/dftb/data-$i/"
    file=$(find $filepath -name "*.bqb")
    if [[ ! -n $file ]]
    then
        echo $i
    fi
done
