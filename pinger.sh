#!/bin/bash
for x in {1..4} ; do
  (printf "%s " "$x"; ping -c 1 google.com 2>1 | awk '/time=/{sub("time=","");print $7}') ||break;sleep 15; done
