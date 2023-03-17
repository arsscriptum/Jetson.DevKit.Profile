#!/bin/sh

tmpfname=`cat /dev/urandom | tr -dc '[:alpha:]' | fold -w ${1:-20} | head -n 1`
fulltmpfilepath=$(printf "%s/%s.%s" "/home/gp/tmp" "$tmpfname" "log")

export TMPLOGFILE="$fulltmpfilepath"

maininclude=/home/gp/scripts/includes/function_helpers.sh

if [ -d "$maininclude" ]; then
        echo "ERROR : could not find dependency $maininclude"
        exit 1;
else
        . $maininclude
        setup_log "sourcing $maininclude"
fi


setup_log "UPDATING LOCAL SCRIPTS"

cd /home/gp/jetson

git pull

varzero=0
conflicted=`git status | grep 'both modified:' | wc -l`

if [ $conflicted -gt $varzero ];
 then
    setup_log "Error: merge problem. Resolve and continue manually."
    exit 1
 else
    setup_log "no merge issues."
fi

tmpfname=`cat /dev/urandom | tr -dc '[:alpha:]' | fold -w ${1:-20} | head -n 1`
fulltmpfile=$(printf "%s/%s.%s" "/home/gp/tmp" "$tmpfname" "out")

setup_log "copy and save in file $fulltmpfile"

validate_folder ~/scripts
cp -R --force --update --verbose /home/gp/jetson/scripts/* /home/gp/scripts > $fulltmpfile

num_copied=`tail "$fulltmpfile" |  grep "\->" | wc -l`
output=`tail "$fulltmpfile"`

setup_log "number of copied files : $num_copied"

if [ $num_copied -gt $varzero ];
 then
    setup_log "copy details : $output"
 else
    setup_log "no files copied"
fi

