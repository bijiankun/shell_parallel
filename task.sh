#!/bin/bash
file=$1
result=${file}".result"
while read line
do
	curl -s "http://host:port/submit_task" -d "param=${line}" >> $result
echo "" >> $result
done < $1
echo $file >> finished.log
