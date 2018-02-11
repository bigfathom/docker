#!/bin/bash

echo Starting $0
source mysettings.env

TAG_NAME=$1
if [ -z "$TAG_NAME" ]; then
    TAG_NAME="latest"
fi

echo "... IMAGE NAME = ${IMAGE_NAME}"
echo "... TAG NAME   = ${TAG_NAME}"

CMD_LOCAL="docker run -ti local/${IMAGE_NAME}:${TAG_NAME} /bin/bash"
CMD_GENERAL="docker run -ti ${IMAGE_NAME}:${TAG_NAME} /bin/bash"

echo $CMD_LOCAL
eval $CMD_LOCAL
if [ $? -ne 0 ]; then
    echo "Failed to run local/${IMAGE_NAME}:${TAG_NAME}; will try to pull now ..."
    docker pull ${IMAGE_NAME}:${TAG_NAME}
    echo $CMD_GENERAL
    eval $CMD_GENERAL
fi

echo
