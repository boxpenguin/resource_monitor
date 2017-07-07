#!/bin/bash
# Dev: Jordan C. Uehara (Jordan.C.Uehara@nasa.gov)
# Mission: IceSAT2: SIPS

# Mailer script that uses resource_monitor perl script to see if there was a problem
# Defined by variables in resource_monitor, which the default non-error code is a single line


tmpfile="resource_monitor.tmp"
host=$(hostname)
mailarray="Jordan.C.Uehara@nasa.gov"
LOG="/var/log/resource_monitor.log"

# Test if tmpfile exists, if it does remove it and run resource_monitor outputing to the tmpfile
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

# Send output to varlog regardless
if [ -e $LOG ]; then
  cat $tmpfile >> $LOG
else
  echo "File does not exist" $LOG
  sudo touch $LOG
  sudo chmod 666 $LOG
  cat $tmpfile >> $LOG
fi

# Test if there is more than one line in tmpfile
lines=$(wc -l $tmpfile| awk '{print $1}')
if [ $lines -ne 1 ]; then
  cat $tmpfile | mail -s "Alert on Host: $host" $mailarray
fi

# Catch all for tmpfile
rm -f $tmpfile
