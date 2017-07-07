#!/bin/bash

# Script to see if the monitoring was tripped by creating sentinel temp file

tmpfile="resource_monitor.tmp"
host=$(hostname)
mailarray="Jordan.C.Uehara@nasa.gov"
LOG="/var/log/resource_monitor.log"
if [ -e $tmpfile ]; then
  rm -f $tmpfile 2>/dev/null
  touch $tmpfile
  chmod 666 $tmpfile
  ./resource_monitor $tmpfile
else
  touch $tmpfile
  chmod 666 $tmpfile
  ./resource_monitor $tmpfile
fi

# Send output to varlog regardless!
cat $tmpfile >> $LOG
lines=$(wc -l $tmpfile| awk '{print $1}')
# If there is more than the default one line then mail an alert
if [ $lines -ne 1 ]; then
  cat $tmpfile | mail -s "Alert on Host: $host" $mailarray
fi

rm -f $tmpfile
