#!/bin/bash
ARG=$1
echo Starting $0 $ARG
echo
LS_CMD="docker volume ls | grep _bigfathom_preview"
echo $LS_CMD
eval $LS_CMD
echo
echo "Press ANY KEY now to ERASE ALL YOUR BIGFATHOM DATA! (Or CTRL-C to ABORT now)"
read

echo "Erasing contents the docker volumes ..."
rm -rf /var/lib/docker/volumes/db_bigfathom_preview/_data/*
rm -rf /var/lib/docker/volumes/appserver_web_bigfathom_preview/_data/*
rm -rf /var/lib/docker/volumes/appserver_bucket_bigfathom_preview/_data/*

echo
echo $LS_CMD
eval $LS_CMD
echo

echo
echo "Finished $0"
