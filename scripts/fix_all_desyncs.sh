#!/bin/sh

# generate a random string
tmpfname=`cat /dev/urandom | tr -dc '[:alpha:]' | fold -w ${1:-20} | head -n 1`

# create a unique filename in tmp folder for logs
fulltmpfile=$(printf "%s/%s.%s" "$MYTMP" "$tmpfname" "out")

# export the filename
export TMPLOGFILE=$fulltmpfile

maininclude=/home/gp/scripts/includes/function_helpers.sh

if [ -d "$maininclude" ]; then
        echo "ERROR : could not find dependency $maininclude"
        exit 1;
else
        . $maininclude
        setup_log "sourcing $maininclude"
fi



invoke_reconfigure_packages_sources () {

	sudo rm -f /etc/apt/sources.list.d/* >> $TMPLOGFILE

	sudo dpkg --configure -a >> $TMPLOGFILE
}

invoke_packages_reprocessing () {

	setup_log "Run the upgrade (which will fail)" 

	sudo apt-get upgrade >> $TMPLOGFILE

	setup_log "Then install the files we can from the cache (will succeed for some, but fail for others)"

	sudo dpkg -i /var/cache/apt/archives/*.deb >> $TMPLOGFILE

	setup_log "Reconfigure it and other packages (will mostly succeed)"

	sudo dpkg --configure -a >> $TMPLOGFILE

	setup_log "Make a bit more more progress from cache (succeed for some, fail for others)"

	sudo dpkg -i /var/cache/apt/archives/*.deb >> $TMPLOGFILE

	setup_log "Now run another upgrade which will download needed packages (will fail on install)"

	sudo apt-get upgrade >> $TMPLOGFILE

	setup_log "Install again from cache (will succeed!)"

	sudo dpkg -i /var/cache/apt/archives/*.deb >> $TMPLOGFILE
}


invoke_reconfigure_packages_sources

invoke_packages_reprocessing