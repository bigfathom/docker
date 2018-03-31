#!/bin/bash
VERSIONINFO=20180331.1

echo "Starting $0 v$VERSIONINFO"
echo

declare -a arr=("db_bigfathom_preview" "appserver_web_bigfathom_preview" "appserver_bucket_bigfathom_preview")

LS_CMD="docker volume ls | grep _bigfathom_preview | awk '{print \$NF}'"
echo $LS_CMD
eval $LS_CMD
echo

VOLNAMES=$(eval $LS_CMD)
if [ -z "$VOLNAMES" ]; then
    echo "No volumes found to kill"
    exit 2
fi

#for volname in "${arr[@]}"
for VOLNAME in $VOLNAMES
do
    CMD="docker inspect $VOLNAME"
    echo "$CMD"
    eval "$CMD"
    echo
done

echo
read -r -p "QUESTION: DESTROY ALL YOUR BIGFATHOM DATA? [y/N] " response
case "$response" in
    [yY]) 
        ;;
    *)
        echo "Aborted the $0 script!"
        echo
        exit 1
        ;;
esac
echo

echo "Removing the docker volumes ..."

for VOLNAME in "${arr[@]}"
do
    VPATH="/var/lib/docker/volumes/$VOLNAME"
    if [ ! -d "$VPATH" ]; then
        echo "No volume found for $VOLNAME"
    else
        DPATH="$VPATH/_data"
        if [ -L "$DPATH" ]; then
            echo "SYMLINK found for $VOLNAME"
            #Remove the existing symlink that causes Docker trouble
            RM_CMD="sudo rm $DPATH"
            echo "$RM_CMD"
            eval "$RM_CMD"
            #Create an empty data directory for Docker to find
            MKDIR_CMD="sudo mkdir $DPATH"
            echo "$MKDIR_CMD"
            eval "$MKDIR_CMD"
        fi
        CMD="docker volume rm $VOLNAME"
        echo "$CMD"
        eval "$CMD"
        echo
    fi
done

#Check final result
echo
echo $LS_CMD
eval $LS_CMD
echo
VOLNAMES=$(eval $LS_CMD)
if [ -z "$VOLNAMES" ]; then
    echo "Successfully removed all volumes!"
else
    echo
    echo "ERROR FAILED to remove one or more volumes!!!"
    exit 1
fi

echo
echo "Finished $0"
