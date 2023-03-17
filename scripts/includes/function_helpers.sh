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
