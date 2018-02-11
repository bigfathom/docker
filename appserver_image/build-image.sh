#!/bin/bash

echo Starting $0
source mysettings.env

TAG_NAME=$1
if [ -z "$TAG_NAME" ]; then
    TAG_NAME="latest"
fi

echo "... IMAGE NAME = ${IMAGE_NAME}"
echo "... TAG NAME   = ${TAG_NAME}"

CMD="docker build --rm -t local/${IMAGE_NAME}:${TAG_NAME} ."

echo $CMD
eval $CMD
echo
