#!/bin/bash

b=0
n=60000
for ((i=$b; i<$n; i+=2)) do
    filepath="$SCRATCH/dftb-ipi/dftb/data-$i/"
    file=$(find $filepath -name "*.emp")
    if [[ ! -n $file ]]
    then
        echo $i
    fi
done
