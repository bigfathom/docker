#!/bin/bash

echo "Starting $0"

echo
echo docker --version
docker --version
if [ $? -ne 0 ]; then
    echo
    echo "ERROR --- docker utility might not be properly installed!!!!"
    echo
fi

echo 
echo docker-compose --version
docker-compose --version
if [ $? -ne 0 ]; then
    echo
    echo "ERROR --- docker-compose utility might not be properly installed!!!!"
    echo
fi

echo
echo "LOCAL BIGFATHOM CONTAINERS..."
echo "docker ps -a | grep bigfathom"
docker ps -a | grep bigfathom

echo
echo "LOCAL BIGFATHOM IMAGES..."
echo "docker image ls | grep bigfathom"
docker image ls | grep bigfathom

echo
echo "Finished $0"


