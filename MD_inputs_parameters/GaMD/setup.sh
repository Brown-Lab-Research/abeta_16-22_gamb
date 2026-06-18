#!/bin/bash

# Populate header with queue stuff, modules, etc.

base="tetramer"     # replace this with your PDB code or however you want to name it
ff="c36"

for (( i=198; i<201; i++ ))
do
    j="$(($i-1))"

    # set base file name for inputs to be read (previous state)
    if [[ $i -eq 1 ]];
    then
        basename="gamd_equil"
    else		
	basename="${base}_${ff}_${j}"
    fi
    
    # generate input file from template
    # replace the placeholders with current interval file names
    sed "s/<BASENAME>/${basename}/g" md.template > md.${i}.in
    sed -i "s/<BASE>/${base}/g" md.${i}.in
    sed -i "s/<CURR>/${i}/g" md.${i}.in

    # random number of processors chosen, update
    #/cm/shared/apps/slurm/current/bin/srun -n 48 $NAMDIR/namd2 md.${i}.in > md.${i}.out   
    $NAMDIR/charmrun +p288 ++mpiexec ++remote-shell srun $NAMDIR/namd2 md.${i}.in > md.${i}.out
done

exit;
