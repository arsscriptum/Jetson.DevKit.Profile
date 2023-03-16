#!/bin/sh

datestr=`date`
TMPLOGFILE=$MYTMP/test_script.1.log
11111
rm -rf $TMPLOGFILE
11111
setup_log () {
  datestr=`date`
  echo "[$datestr] $1" >> $TMPLOGFILE
  echo "[$datestr] $1"
}

setup_log "Test Script No 1 Running..." 


<<<<<<< HEAD
setup_log "Script Test 1 Done."
=======
setup_log "Script Test 1 Done."


>>>>>>> bf2d5c4a0e4a98951f338b9a3e4dbb9e9f194af5
