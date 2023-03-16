#!/bin/sh


#!/bin/sh

datestr=`date`
TMPLOGFILE=$MYTMP/fix_apt.log

rm -rf $TMPLOGFILE

setup_log () {
  datestr=`date`
  echo "[$datestr] $1" >> $TMPLOGFILE
  echo "[$datestr] $1"
}

setup_log "Fix Started" 


for i in $(dpkg -l|awk '/^ii/ {print $2}')
do
	setup_log "einstall $i"
    sudo apt-get --reinstall -y install $i
done

setup_log "DONE"

#dpkg -l | grep ii | awk '{print "apt-get --reinstall -y install", $2}' > /tmp/reinstall
#sh /tmp/reinstall
setup_log "apt-get --reinstall install ucf"
apt-get --reinstall install ucf