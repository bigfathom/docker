#!/bin/bash

echo "Starting $0"

echo "PULL ALL THE IMAGES FROM REGISTRY FOR THIS STACK"
echo

CMD="docker-compose pull"
echo $CMD
eval $CMD

echo "Finished $0"


