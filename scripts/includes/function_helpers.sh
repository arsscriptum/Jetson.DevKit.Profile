#!/bin/sh

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

invoke_install () {
	APP="$1"

	setup_log "installing $APP"

	sudo apt-get -y install $APP >> $TMPLOGFILE
}


invoke_remove () {
	APP="$1"

	setup_log "installing $APP"

	sudo apt-get -y remove $APP >> $TMPLOGFILE
}

invoke_reinstall () {
	APP="$1"
	export TMPPROGRESSFILE=$MYTMP/reinstall_progress.log
	export CURRENTTIME=`date`

	logstring=$(printf "[%s / %s] reinstalling %s" "$UPDATEDAPPS" "$TOTALAPPS" "$APP")
	progressstring=$(printf "[%s / %s]\nStarted Time %s\nCurrent Time %s" "$UPDATEDAPPS" "$TOTALAPPS" "$STARTEDDATE" "$CURRENTTIME")
	setup_log "$logstring"
	echo "$progressstring" > $TMPPROGRESSFILE
	#sudo apt-get -y --reinstall install $APP >> $TMPLOGFILE
	#sudo apt reinstall install $APP >> $TMPLOGFILE
	valueone=1
	UPDATEDAPPS=$((UPDATEDAPPS + valueone))
}

invoke_full_reinstall () {

	setup_log "reinstalling using aptitude"

	sudo aptitude reinstall '~i' >> $TMPLOGFILE
}
