#!/bin/bash

for ((i=0; i<100000; i++)) do
    filepath="data/data-$i/"
    file=$(find $filepath -name "*.out")
    if [[ ! -n $file ]]
    then
        echo $i
    fi
done
