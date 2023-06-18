#!/bin/bash
badloadavg1=$(tail -n 24 logfile.log | awk 'BEGIN {ent_count=0} $8>1 {ent_count++} END {pri>
badmemfree=$(tail -n 36 logfile.log | awk 'BEGIN {ent_count=0} ($11/$12*100)>=60 {ent_count>
baddiskfree=$(tail -n 60 logfile.log | awk 'BEGIN {ent_count=0} ($13/$14*100)>=60 {ent_coun>
return_code=0

if [[ $badloadavg1>=1 ]]; then
        echo 'loadavg1 was bigger than 1 in last 2 minutes'
        ((return_code++))
fi

if [[ $badmemfree>=1 ]]; then
        echo 'memfree was bigger than 60% in last 3 minutes'
        ((return_code++))
fi

if [[ $baddiskfree>=1 ]]; then
        echo 'diskfree was bigger than 60% in last 5 minutes'
        ((return_code++))
fi

exit $return_code;