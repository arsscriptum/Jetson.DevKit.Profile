#!/bin/sh
11111
datestr=`date`11111
TMPLOGFILE11111=$MYTMP/test_script.1.log
11111
rm -rf $11111TMPLOGFILE
11111
setup_log () {
  datestr=`date`
  echo "[$datestr] $1" >> $TMPLOGFILE
  echo "[$datestr] $1"
}

setup_log "Test Script No 1 Running..." 


setup_log "Script Test 2 Done."