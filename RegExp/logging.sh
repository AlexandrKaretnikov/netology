#!/bin/bash
while true; do
        timestamp=$(date)
        loadavg=$(cat /proc/loadavg | awk '{print $1, $2, $3}')
        memfree=$(free | awk 'NR==2 {print $4}')
        memtotal=$(free | awk 'NR==2 {print $2}')
        diskfree=$(df | awk '$6=="/" {print $4}')
        disktotal=$(df | awk '$6=="/" {print $2}')
        echo $timestamp $loadavg $memfree $memtotal $diskfree $disktotal >> logfile.log
        sleep 5
done

