#!/bin/sh

datestr=`date`
TMPLOGFILE=$MYTMP/updatescripts.log

rm -rf $TMPLOGFILE

setup_log () {
  datestr=`date`
  echo "[$datestr] $1" >> $TMPLOGFILE
  echo "[$datestr] $1"
}

validate_folder () {
	DIR="$1"

	setup_log "validate_folder $DIR"

	if [ ! -d "$DIR" ]; then
		setup_log "creating $DIR"
	   	mkdir $DIR
	fi
	setup_log "setting rights on $DIR"
	chmod -R 755 $DIR
}


setup_log "UPDATING LOCAL SCRIPTS"

cd ~/Jetson.DevKit.Profile 

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
fulltmpfile=$(printf "%s/%s.%s" "$MYTMP" "$tmpfname" "out")

setup_log "copy and save in file $fulltmpfile"

validate_folder ~/scripts
cp -R --force --update --verbose ~/Jetson.DevKit.Profile/scripts/* ~/scripts > $fulltmpfile

num_copied=`tail "$fulltmpfile" |  grep "\->" | wc -l`
output=`tail "$fulltmpfile"`

setup_log "number of copied files : $num_copied"

if [ $num_copied -gt $varzero ];
 then
    setup_log "copy details : $output"
 else
    setup_log "no files copied"
fi

