#!/bin/bash
VERSIONINFO="20180212.3"
echo "Starting $0 v$VERSIONINFO"
echo "DOCKERFILE_MACHINEBUILD_VERSION=$DOCKERFILE_MACHINEBUILD_VERSION"
echo

PARAM1=$1
if [ -z "$PARAM1" ]; then
    echo "... NO PARAMS"
else
    echo "... PARAM1=$PARAM1"
fi

DELAY=6
echo "Will try to start apache2 in $DELAY seconds ..."
sleep $DELAY
service apache2 start
sleep $DELAY
ps -aux
echo

#Initialize Drupal and Bigfathom if not already initialized once before
NOTINITIALIZEDFLAG="/var/local/bigfathom-bucket/NOT_INITIALIZED_YET.flag"
INITIALIZEDFLAG="/var/local/bigfathom-bucket/INITIALIZED.flag"
if [ -f "$NOTINITIALIZEDFLAG" ]; then
    echo "Found $NOTINITIALIZEDFLAG"
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo
    echo "Initializing Drupal and Bigfathom One Time at $TIMESTAMP ..."
    ACTIVATE_CMD="/var/local/bigfathom-bucket/activate-bigfathom.sh"
    cd /var/www/html
    echo $ACTIVATE_CMD
    eval $ACTIVATE_CMD
    if [ $? -eq 0 ]; then
        #So far so good.
        echo "Removing $NOTINITIALIZEDFLAG"
        rm -f $NOTINITIALIZEDFLAG
        echo "Initialized!"
        echo "INITIALIZED DRUPAL AND BIGFATHOM at $TIMESTAMP" > "$INITIALIZEDFLAG"
        echo "STARTUP SCRIPT=$0 v$VERSIONINFO" >> "$INITIALIZEDFLAG"
        echo "DOCKERFILE_MACHINEBUILD_VERSION=$DOCKERFILE_MACHINEBUILD_VERSION" >> "$INITIALIZEDFLAG"
    fi
    echo
fi
if [ -f "$INITIALIZEDFLAG" ]; then
    ls -la $INITIALIZEDFLAG
else
    echo
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "ERROR: Expected to find $INITIALIZEDFLAG but did NOT!"
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "NOTE: Will continue but something is wrong with your setup!"
    echo
fi

echo "Done starting apache2!"
if [ ! "TERMINATES" = "$PARAM1" ]; then
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "Starting tail at $TIMESTAMP forever to prevent machine termination in $0 v$VERSIONINFO (Machine v$DOCKERFILE_MACHINEBUILD_VERSION)"
    tail -f /dev/null
fi
echo "Completed $0"
