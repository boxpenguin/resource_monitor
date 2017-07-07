#!/bin/bash

# Script to see if the monitoring was tripped by creating sentinel temp file
tmpfile="resource_monitor.tmp"
if [ -e $tmpfile ]; then
  ./resource_monitor $tmpfile
else
  touch $tmpfile
  chmod 666 $tmpfile
fi
