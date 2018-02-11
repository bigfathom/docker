#!/bin/bash
CONTAINER_NAME=applicationstack_appserver_1

echo Opening terminal into the appserver...
docker exec -ti $CONTAINER_NAME /bin/bash
