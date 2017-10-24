#!/bin/bash

logs_file=/home/rv/projects/programming/scripts/bash/battery-logger/logs
echo -n "" > logs

log ()	#$1 - start per. $2 - end per. $3 - time passed
{
	echo "$1% => $2% : $3" >> logs	
}

timer()
{
    if [[ $# -eq 0 ]]; then
        echo $(date '+%s')
    else
        local  stime=$1
        etime=$(date '+%s')

        if [[ -z "$stime" ]]; then stime=$etime; fi

        dt=$((etime - stime))
        ds=$((dt % 60))
        dm=$(((dt / 60) % 60))
        dh=$((dt / 3600))
        printf '%d:%02d:%02d' $dh $dm $ds
    fi
}

start-timer () 
{
	time1=$(timer)
}

finish-timer ()
{
	time2=$(timer $time1)
}

take-probe ()
{
	probe2=$(cat /sys/class/power_supply/BAT0/capacity | tr -d '[[:blank:]]')
}

start-logger ()
{
	take-probe
	if [ "$1" != "$probe2" ]
	then
		finish-timer
		log $1 $probe2 $time2
		start-timer
		start-logger $probe2
	else
		sleep 1
		start-logger $1
	fi
}
probe1=$(cat /sys/class/power_supply/BAT0/capacity | tr -d '[[:blank:]]')
start-timer
start-logger $probe1
