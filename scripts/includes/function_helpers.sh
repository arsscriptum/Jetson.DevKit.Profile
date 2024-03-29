#!/bin/sh

setup_log () {
  datestr=`date`
  echo "[$datestr] $1" &>> $TMPLOGFILE
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

	sudo apt-get -y install $APP 2>> $STDERRLOG 1>> $STDOUTLOG
}


invoke_remove () {
	APP="$1"

	setup_log "installing $APP"

	sudo apt-get -y remove $APP 2>> $STDERRLOG 1>> $STDOUTLOG
}

invoke_reinstall () {
	APP="$1"
	export TMPPROGRESSFILE=$MYTMP/reinstall_progress.log
	CURRENTTIME=`date`
	PERCENTAGE=$(( (UPDATEDAPPS * 100) / TOTALAPPS )) 
	separator="========================================="

	logstring=$(printf "[%s / %s] [%s %%] reinstalling %s" "$UPDATEDAPPS" "$TOTALAPPS" "$PERCENTAGE" "$APP")
	progressstring=$(printf "%s\n[%s / %s]\n%s %%\nStarted Time %s\nCurrent Time %s\n%s" "$separator" "$UPDATEDAPPS" "$TOTALAPPS" "$PERCENTAGE" "$STARTEDDATE" "$CURRENTTIME" "$separator")

	setup_log "$logstring"
	echo "$progressstring" > $TMPPROGRESSFILE
	sudo apt-get -y --reinstall install $APP 2>> $STDERRLOG
	sudo apt reinstall install $APP 2>> $STDERRLOG
	valueone=1
	UPDATEDAPPS=$((UPDATEDAPPS + valueone))
}

invoke_full_reinstall () {

	setup_log "reinstalling using aptitude"

	sudo aptitude reinstall '~i' 2>> $STDERRLOG 1>> $STDOUTLOG
}
