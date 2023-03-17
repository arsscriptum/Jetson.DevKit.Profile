#!/bin/sh

if [ -d "$SDCARD_TEMP" ]
then
        export DOWNLOAD_PATH="$SDCARD_TEMP"
else
        mkdir /home/gp/tmp/download
        export DOWNLOAD_PATH="/home/gp/tmp/download"
fi

echo "download path configured to $DOWNLOAD_PATH"