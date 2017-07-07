#!/usr/bin/python
# Dev: Jordan C. Uehara (Jordan.C.Uehara@nasa.gov)
# Mission: IceSAT2: General

# Version: 1.0
# 1.0: Initial development

# TODO
# 1.x: fix imports
# 2.x: rewrite as threaded script so that multiple pings can occur on time

import subprocess, re, time
from datetime import datetime
from datetime import timedelta

regex = r"time=(\d+(.)(\d+))"

# Set target configuration file and init array
targets_conf = "targets.conf"
targets = []

def ping(host="google.com"):
    try:
        command = "ping -c 1 " + host + " > ping.tmp 2>&1"
        output = subprocess.check_output(command, shell=True, stderr=subprocess.PIPE)
        with open("ping.tmp") as tmpfile:
            for line in tmpfile:
                if "time=" in line:
                    match = re.search(regex, line)
                    results = match.group(1)
                    date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                    # Output as tab seperated columns
                    print date + "\t" + host + "\t" + results
    except subprocess.CalledProcessError as e:
        output = e.output

# Load targets fron configuration file
with open(targets_conf) as target_file:
    for line in target_file:
        targets.append(line.rstrip('\n'))

# Actual work
for target in targets:
    for x in range(3):
        ping(target)
        time.sleep(15)
    ping(target)
