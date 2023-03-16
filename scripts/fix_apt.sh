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
	setup_log "reinstall $i"
    sudo apt-get --reinstall -y install $i
done

setup_log "DONE"

setup_log "Fix Started 2 " 
for x in  $(dpkg -l| awk '/^ii  apt/ {print $2}'); 
do 
	setup_log "reinstall $x"
	apt-get install --reinstall ${x} -y ; 
done

setup_log "Fix Started 3" 
setup_log "outputing in $MYTMP/reinstall.sh"

dpkg -l | grep ii | awk '{print "apt-get --reinstall -y install", $2}' > $MYTMP/reinstall.sh
sh $MYTMP/reinstall.sh
setup_log "apt-get --reinstall install ucf"
apt-get --reinstall install ucf