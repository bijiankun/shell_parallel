#!/bin/bash
# sh schedule.sh uid.txt 30
bigfile=$1
thread=$2
if [ -n "$bigfile" ] && [  -f "$bigfile" ]
then
	echo "file: $bigfile check ok."
else
	echo "file: $bigfile is invalid."
fi

if [ -z $thread ]
then
	thread=10;
fi

bigfiledir=bigfiledir
mdkir ${bigfiledir}
# split bigfile to lots of small files into ${bigfiledir}, each small file get 10000 lines
split -l 10000 -a 3 -d $bigfile ${bigfiledir}/splited.
> committed.log
> finished.log

ls ${bigfiledir}/splited.* | while read f
do
	committed=`wc -l committed.log | awk '{print $1}'`;
	finished=`wc -l finished.log | awk '{print $1}'`;
	running=$(($committed - $finished));
	while [ $running -ge $thread ]
	do 
		echo "running: $running, committed: $committed, finished: $finished, sleep 10s";
		sleep 10;
		committed=`wc -l committed.log | awk '{print $1}'`;
        	finished=`wc -l finished.log | awk '{print $1}'`;
        	running=$(($committed - $finished));
	done
	echo $f >> committed.log
	sh task.sh $f &
done
