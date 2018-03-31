#!/bin/bash

VERSIONINFO=20180331.1
echo "Starting $0 v$VERSIONINFO"

ARG1=$1
ARG2=$2
if [ ! "NOPULL" = "$ARG1" ]; then
    #Output to terminal without locking it
    PULL_CMD="docker-compose pull"
    echo $PULL_CMD
    eval $PULL_CMD
    echo
fi
if [ -z "$ARG2" ]; then
    LASTARG=$ARG1
else
    LASTARG=$ARG2
fi
if [ ! "BINDTERMINAL" = "$LASTARG" ]; then
    #Output to terminal without locking it
    LASTARG="&"
else
    #Output to terminal and lock it to our stack
    LASTARG=""
fi

CMD="docker-compose up $LASTARG"
DOCKER_UTIL="docker-compose"
WHICH=$(which $DOCKER_UTIL)
if [ -z "$WHICH" ]; then
    echo
    echo "ERROR --- Missing the docker-compose utility!"
    echo "To launch this stack you need version 1.16 or better installed on your computer."
    echo "Download and install it from Docker.com"
    echo
    exit 1
fi

echo "$CMD"
eval "$CMD"

echo "Finished $0 v$VERSIONINFO"
