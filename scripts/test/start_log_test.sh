#!/bin/sh

datestr=`date`
TMPLOGFILE=$MYTMP/test_script.progress.log

rm -rf $TMPLOGFILE

setup_log () {
  datestr=`date`
  echo "[$datestr] $1" >> $TMPLOGFILE
  echo "[$datestr] $1"
}

setup_log "Setup Started" 

setup_log "Run script 1"

/home/gp/scripts/test/run_test_1.sh

setup_log "Run script 2"

/home/gp/scripts/test/run_test_2.sh