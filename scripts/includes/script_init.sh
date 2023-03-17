#!/bin/sh

# generate a random string
tmpfname=`cat /dev/urandom | tr -dc '[:alpha:]' | fold -w ${1:-20} | head -n 1`

# create a unique filename in tmp folder for logs
fulltmpfile=$(printf "%s/%s.%s" "/home/gp/tmp" "$tmpfname" "log")

fullstdoutlog=$(printf "%s/%s-%s.%s" "/home/gp/log" "stdout" "$tmpfname" "log")

fullstderrlog=$(printf "%s/%s-%s.%s" "/home/gp/log" "stderr" "$tmpfname" "out")


# export the filename
export TMPLOGFILE=$fulltmpfile
export STDERRLOG=$fullstdoutlog
export STDOUTLOG=$fullstderrlog