#!/bin/bash
ARG=$1
echo Starting $0 $ARG
echo
LS_CMD="docker volume ls | grep _bigfathom_preview"
echo $LS_CMD
eval $LS_CMD
echo
echo "Press ANY KEY now to CREATE BIGFATHOM docker volumes! (Or CTRL-C to ABORT now)"
read

echo "Creating the docker volumes ..."
docker volume create $ARG db_bigfathom_preview
docker volume create $ARG appserver_web_bigfathom_preview
docker volume create $ARG appserver_bucket_bigfathom_preview

echo
echo $LS_CMD
eval $LS_CMD
echo

echo
echo "Finished $0"
