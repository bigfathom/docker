#!/bin/bash

echo "Starting $0"

echo "SHOW ALL RUNNING AND STOPPED CONTAINERS"

CMD="docker ps -a"
echo $CMD
eval $CMD

echo "Finished $0"
