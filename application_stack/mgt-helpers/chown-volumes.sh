#!/bin/bash

VERSIONINFO="20180215.1"
echo "Started $0 v$VERSIONINFO"

BUCKET_NAME="appserver_bucket_bigfathom_preview"
WEB_NAME="appserver_web_bigfathom_preview"

NATIVE_DOCKER_VOLUME_PATH="/var/lib/docker/volumes"
NATIVE_DOCKER_PATH_BUCKET="${NATIVE_DOCKER_VOLUME_PATH}/${BUCKET_NAME}"
NATIVE_DOCKER_PATH_WEB="${NATIVE_DOCKER_VOLUME_PATH}/${WEB_NAME}"

USERNAME=$1
if [ -z "$USERNAME" ]; then
    USERNAME=$(whoami)
fi

function showUsage()
{
    echo
    echo "PURPOSE: Change ownership of the volumes."
    echo
    echo "USAGE: $0 [USERNAME]"
    echo "USERNAME = Username, defaults to result of whoami call."
    echo
}

showUsage

echo "... DOCKER NATIVE ROOT        = $NATIVE_DOCKER_VOLUME_PATH"
echo "... NATIVE_DOCKER_PATH_BUCKET = $NATIVE_DOCKER_PATH_BUCKET"
echo "... NATIVE_DOCKER_PATH_WEB    = $NATIVE_DOCKER_PATH_WEB"
echo "... USERNAME                  = $USERNAME"

UNAME=$(uname)
shopt -s nocasematch
case "$UNAME" in "LINUX" ) 
;;
*) 
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "WARNING: This does NOT appear to be a linux system!  Script MAY NOT WORK!"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    uname -a
;;
esac
shopt -u nocasematch

echo
echo "Press CTRL-C now to cancel or any other key to continue!"
echo "NOTE: You will be prompted for your sudo password for some steps"
read

function chownOwnership()
{
    echo
    FOLDERNAME=$1
    RAWPATH="${NATIVE_DOCKER_VOLUME_PATH}/${FOLDERNAME}"
    if sudo [ ! -d "$RAWPATH" ]; then
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo "ERROR: Did NOT find folder for volume $FOLDERNAME"
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        return 2
    fi
    FULLPATH="${RAWPATH}/_data"
    if sudo [ -L "$FULLPATH" ]; then
        echo "NOTE: $RAWPATH is symlinked"
        CHOWNPARAM=" -h "
    else
        echo "NOTE: $RAWPATH is not symlinked"
        CHOWNPARAM=""
    fi

    echo
    CMD="sudo chown ${CHOWNPARAM} $USERNAME:$USERNAME * -R"
    echo $CMD
    eval $CMD

    CMD="sudo chown ${CHOWNPARAM} $USERNAME:$USERNAME .* -R"
    echo $CMD
    eval $CMD

    echo
    sudo ls -la ${FULLPATH}

    return 0
}

chownOwnership "$BUCKET_NAME"
chownOwnership "$WEB_NAME"

echo
echo "Finished $0"