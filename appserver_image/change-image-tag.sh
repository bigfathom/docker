#!/bin/bash

echo Starting $0
source mysettings.env

CURRENT_TAG_NAME=$1
NEW_TAG_NAME=$2

function showUsage()
{
    echo "PURPOSE: Save an image to your docker image collection with a new TAG"
    echo
    echo "USAGE: $0 CURRENT_TAG_NAME NEW_TAG_NAME"
    echo
    echo Current bigfathom images ...
    docker image ls | grep "bigfathom"
    echo
}

if [ -z "$CURRENT_TAG_NAME" ]; then
    echo "ERROR missing CURRENT_TAG_NAME"
    showUsage
    exit 2
fi
if [ -z "$NEW_TAG_NAME" ]; then
    echo "ERROR missing NEW_TAG_NAME"
    showUsage
    exit 2
fi
if [ "$CURRENT_TAG_NAME" = "$NEW_TAG_NAME" ]; then
    echo "ERROR CURRENT_TAG_NAME same as NEW_TAG_NAME"
    showUsage
    exit 2
fi

echo "... IMAGE NAME = ${IMAGE_NAME}"
echo "... CURRENT TAG NAME   = ${CURRENT_TAG_NAME}"
echo "... NEW TAG NAME   = ${NEW_TAG_NAME}"

CMD_TAG="docker tag ${IMAGE_NAME}:${CURRENT_TAG_NAME} ${IMAGE_NAME}:${NEW_TAG_NAME}"
echo $CMD_TAG
eval $CMD_TAG
echo
