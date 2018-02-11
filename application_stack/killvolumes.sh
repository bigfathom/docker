#!/bin/bash
ARG=$1
echo Starting $0 $ARG
echo
LS_CMD="docker volume ls | grep _bigfathom_preview"
echo $LS_CMD
eval $LS_CMD
echo
echo "Press ANY KEY now to DESTROY ALL YOUR BIGFATHOM DATA! (Or CTRL-C to ABORT now)"
read

echo "Removing the docker volumes ..."
docker volume rm $ARG db_bigfathom_preview
docker volume rm $ARG appserver_web_bigfathom_preview
docker volume rm $ARG appserver_bucket_bigfathom_preview

echo
echo $LS_CMD
eval $LS_CMD
echo

echo
echo "Finished $0"
