#!/bin/bash

echo Starting $0
source mysettings.env

TAG_NAME=$1
if [ -z "$TAG_NAME" ]; then
    TAG_NAME="latest"
fi

echo "... IMAGE NAME = ${IMAGE_NAME}"
echo "... TAG NAME   = ${TAG_NAME}"

CMD_LOGIN="docker login"
echo $CMD_LOGIN
eval $CMD_LOGIN
echo

CMD_TAG="docker tag local/${IMAGE_NAME}:${TAG_NAME} ${IMAGE_NAME}:${TAG_NAME}"
echo $CMD_TAG
eval $CMD_TAG
echo

CMD_PUSH="docker push ${IMAGE_NAME}:${TAG_NAME}"
echo $CMD_PUSH
eval $CMD_PUSH
echo
