#!/bin/bash

VERSIONINFO="20180331.1"
echo "Started $0 v$VERSIONINFO"

STACKNAME="application_stack"

BUCKET_NAME="appserver_bucket_bigfathom_preview"
WEB_NAME="appserver_web_bigfathom_preview"

NATIVE_DOCKER_VOLUME_PATH="/var/lib/docker/volumes"
NATIVE_DOCKER_PATH_BUCKET="${NATIVE_DOCKER_VOLUME_PATH}/${BUCKET_NAME}"
NATIVE_DOCKER_PATH_WEB="${NATIVE_DOCKER_VOLUME_PATH}/${WEB_NAME}"

TARGETROOT=$1
if [ -z "$TARGETROOT" ]; then
    TARGETROOT="$HOME/docker-appdata"
fi

function showUsage()
{
    echo
    echo "PURPOSE: Softlink the application data OUT OF the docker native volumes"
    echo "         folder into a different root folder."
    echo
    echo "USAGE: $0 [TARGETROOT]"
    echo "TARGETROOT = Full path to where the volume softlinks will point"
    echo
}

showUsage

echo "... DOCKER NATIVE ROOT        = $NATIVE_DOCKER_VOLUME_PATH"
echo "... NATIVE_DOCKER_PATH_BUCKET = $NATIVE_DOCKER_PATH_BUCKET"
echo "... NATIVE_DOCKER_PATH_WEB    = $NATIVE_DOCKER_PATH_WEB"
echo "... TARGETROOT                = $TARGETROOT"
echo "... STACKNAME                 = $STACKNAME"
if [ ! -d "$TARGETROOT" ]; then
    echo "NOTE: $TARGETROOT does NOT already exist; it will be created"
fi

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

if [ ! -d "$TARGETROOT" ]; then
    CMD="mkdir -p $TARGETROOT"
    echo $CMD
    eval $CMD
    CMD="chmod 777 $TARGETROOT"
    echo $CMD
    eval $CMD
    echo "WARNING: The permissions on $TARGETROOT are wide-open!"
    echo "TIP: Lock them down so only your user can rwx in their content"
    echo
fi

POINTFAILED="NO"
function convertDockerVolume2Symlink()
{
    echo
    VOLNAME=$1
    RAWPATH="${NATIVE_DOCKER_VOLUME_PATH}/${VOLNAME}"
    if sudo [ ! -d "$RAWPATH" ]; then
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        echo "ERROR: Did NOT find folder for volume $VOLNAME"
        echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        return 2
    fi
    FULLPATH="${RAWPATH}/_data"
    if sudo [ -L "$FULLPATH" ]; then
        echo "NOTE: $RAWPATH is already symlinked"
        sudo ls -la $FULLPATH
        return 1
    fi

    FULLTARGET="${TARGETROOT}/${STACKNAME}/${VOLNAME}"
    echo "$RAWPATH is NOT already a symlink to a directory"
    echo

    if [ -d "$FULLTARGET" ]; then
        POINTFAILED="YES"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo "FAILED POINTING $VOLNAME because TARGET ALREADY EXISTS!"
        echo "TIP: Rename the target and retry or delete it and retry"
        echo "     $FULLTARGET"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        return 2
    fi

    CMD="mkdir -p $FULLTARGET"
    echo $CMD
    eval $CMD
    if sudo [ -d "$FULLPATH" ]; then
        #Handle case where _data was NOT already deleted
        CMD="sudo mv ${FULLPATH} ${FULLPATH}_REPLACED"
        echo $CMD
        eval $CMD
    fi

    CMD="sudo ln -s ${FULLTARGET} ${FULLPATH}"
    echo $CMD
    eval $CMD

    CMD="sudo chmod 777 ${FULLPATH}"
    echo $CMD
    eval $CMD
    echo "WARNING: The permissions on $FULLPATH are wide-open!"
    sudo ls -la ${FULLPATH}

    return 0
}

convertDockerVolume2Symlink "$BUCKET_NAME"
convertDockerVolume2Symlink "$WEB_NAME"

if [ ! "NO" = "$POINTFAILED" ]; then
    echo
    echo "DETECTED ONE OR MORE ERRORS on pointing the volumes!"
    echo
fi

echo
echo "Finished $0"