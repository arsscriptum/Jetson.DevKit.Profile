#!/bin/sh

datestr=`date`
TMPLOGFILE=$MYTMP/create_virtual_env.progress.log

rm -rf $TMPLOGFILE

setup_log () {
  datestr=`date`
  echo "[$datestr] $1" >> $TMPLOGFILE
  echo "[$datestr] $1"
}


setup_log "Create Virtual Environment"

cd /home/gp/dev

source ~/.bashrc

setup_log "mkvirtualenv"
mkvirtualenv py3cv4 -p python3

setup_log "workon py3cv4"
workon py3cv4