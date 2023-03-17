#!/bin/sh

scriptinit=/home/gp/scripts/includes/script_init.sh

if [ -d "$scriptinit" ]; then
        echo "ERROR : could not find dependency $scriptinit"
        exit 1;
else
        . $scriptinit
        setup_log "sourcing $scriptinit"
fi


maininclude=/home/gp/scripts/includes/function_helpers.sh

if [ -d "$maininclude" ]; then
        echo "ERROR : could not find dependency $maininclude"
        exit 1;
else
        . $maininclude
        setup_log "sourcing $maininclude"
fi

setup_log "downloading cuda"


wget "https://developer.nvidia.com/compute/cuda/9.2/Prod2/local_installers/cuda-repo-ubuntu1604-9-2-local_9.2.148-1_ppc64el" -O /home/gp/Downloads/cuda-repo-ubuntu1604-9-2-local_9.2.148-1_ppc64el.deb -o /home/gp/tmp/out.log

setup_log "unpacking"

sudo dpkg -i /home/gp/Downloads/cuda-repo-ubuntu1604-9-2-local_9.2.148-1_ppc64el.deb

setup_log "set key"

sudo apt-key add /var/cuda-repo-<version>/7fa2af80.pub

setup_log "apt-get update"

sudo apt-get update

setup_log "apt-get install"

sudo apt-get install cuda