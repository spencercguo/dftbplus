#!/bin/bash

b=$1
n=$2
for ((i=$b; i<$n; i++)) do
    filepath="$SCRATCH/dftb-ipi/dftb/data-$i/"
    file=$(find $filepath -name "*.bqb")
    if [[ ! -n $file ]]
    then
        echo $i
    fi
done
