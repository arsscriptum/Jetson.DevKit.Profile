#!/bin/sh

datestr=`date`
TMPLOGFILE=$MYTMP/test.includes.log

rm -rf $TMPLOGFILE

maininclude=/home/gp/scripts/includes/function_helpers.sh

if [ -d "$maininclude" ]; then
        echo "ERROR : could not find dependency $maininclude"
        exit 1;
else
        . $maininclude
        setup_log "sourcing $maininclude"
fi

setup_log "test includes"

tmpfname=`cat /dev/urandom | tr -dc '[:alpha:]' | fold -w ${1:-20} | head -n 1`
fulltmpdir=$(printf "%s/%s" "$MYTMP" "$tmpfname" "out")

setup_log "test create new dir $fulltmpdir"
validate_folder $fulltmpdir


invoke_remove xball

invoke_install xball