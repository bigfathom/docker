#!/bin/bash

VERSIONINFO=20180414.1
echo "Starting $0 v$VERSIONINFO"
source mysettings.env

TAG_NAME=$1
if [ -z "$TAG_NAME" ]; then
    TAG_NAME="latest"
fi

IMAGE_PREFIX=$2
if [ -z "$TAG_NAME" ]; then
    IMAGE_PREFIX=""
else
    IMAGE_PREFIX="${IMAGE_PREFIX}/"
fi

SRC_IMAGE_NAME="${IMAGE_PREFIX}${IMAGE_NAME}"

if [ ! -z "$IMAGE_PREFIX" ]; then
  echo "Create NON '$IMAGE_PREFIX' PREFIXED image image for us to push..."
  CMD_TAG="docker tag ${SRC_IMAGE_NAME}:${TAG_NAME} ${IMAGE_NAME}:${TAG_NAME}"
  echo $CMD_TAG
  eval $CMD_TAG
  echo
fi

echo
echo "CURRENT IMAGES..."
docker image ls | grep "${IMAGE_NAME}" | grep "${TAG_NAME}"
echo

echo
echo "... SOURCE IMAGE NAME = ${SRC_IMAGE_NAME}"
echo "... TAG NAME          = ${TAG_NAME}"
echo

echo "Login to docker..."
CMD_LOGIN="docker login"
echo $CMD_LOGIN
eval $CMD_LOGIN
echo

echo "Share the image..."
CMD_PUSH="docker push ${IMAGE_NAME}:${TAG_NAME}"
echo $CMD_PUSH
eval $CMD_PUSH
echo

echo "Finished $0 v$VERSIONINFO"
echo

