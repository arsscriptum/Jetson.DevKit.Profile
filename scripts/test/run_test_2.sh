#!/bin/sh

datestr=`date`
TMPLOGFILE=$MYTMP/test_script.2.log

rm -rf $TMPLOGFILE

setup_log () {
  datestr=`date`
  echo "[$datestr] $1" >> $TMPLOGFILE
  echo "[$datestr] $1"
}

setup_log "Test Script No 2 Running..." 


setup_log "Validating checksums..."

wget https://arsscriptum.github.io/files/Jetson/setup_scripts_sums.txt -O $MYTMP/setup_scripts_sums.txt -o $MYTMP/out.log

cd /home/gp/scripts/setup
md5sum *.sh > $MYTMP/my_calculated_sums.txt

setup_log "==============="
setup_log "LOCAL CHECKSUMS"

tail $MYTMP/my_calculated_sums.txt

setup_log "================"
setup_log "ONLINE CHECKSUMS"

tail $MYTMP/setup_scripts_sums.txt


setup_log "Script Test 2 Done."