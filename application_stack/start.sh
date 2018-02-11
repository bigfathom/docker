#!/bin/bash

echo "Starting $0"

ARG=$1
if [ ! "BINDTERMINAL" = "$ARG" ]; then
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

echo "Finished $0"
