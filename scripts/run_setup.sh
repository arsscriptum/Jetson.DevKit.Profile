#!/bin/sh

datestr=`date`
TMPLOGFILE=$MYTMP/run_setup.progress.log

rm -rf $TMPLOGFILE

setup_log () {
  datestr=`date`
  echo "[$datestr] $1" >> $TMPLOGFILE
  echo "[$datestr] $1"
}

setup_log "Setup Started" 


setup_log "Getting PreRequisites via get_prerequisites.sh"

/home/gp/scripts/setup/setup_prerequisites.sh

setup_log "######################################################################"
setup_log "Now we can create a virtual environment using the mkvirtualenv command" 

/home/scripts/setup/create_virtual_env.sh

setup_log "Getting Sources via get_important_source.sh" 

/home/gp/scripts/setup/get_important_source.sh


