#!/bin/sh
TEST
TEST
datestr=`date`TEST
TMPLOGFILE=$MYTMP/test_script.1.logTEST
TEST
TESTrm -rf $TMPLOGFILE

setup_log () {
  datestr=`date`
  echo "[$datestr] $1" >> $TMPLOGFILE
  echo "[$datestr] $1"
}

setup_log "Test Script No 1 Running..." 


setup_log "Script Test 2 Done."
