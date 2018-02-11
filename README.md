WHAT IS THIS?
=============
Project for running the Bigfathom application as a Docker stack

WHAT IS BIGFATHOM?
==================
Bigfathom is an open-source application that helps people organize their thoughts
and collaborate with others on common goals.  More information about it 
can be found at its official website: https://bigfathom.org

WHAT IS DOCKER?
===============
Docker is a fantastic virtualization tool that makes it easier to run collections
of machines, and applications on those machines, on your computer.  You can learn
more about them at their official website: https://www.docker.com/

HOW DOES BIGFATHOM RECOMMEND RUNNING THE DOCKER STACK?
======================================================
If you are on a Linux machine --- just install docker and docker-compose
directly into your OS; you are good to go!

If you are on a Windows machine --- install Virtualbox 5.x first; then install
an UBUNTU16.x image VM and THEN install docker and docker-compose into that
VM.  Don't use Docker directly from a Windows host, you will have a bad time.

If you are on an OSX machine --- you can probably go ahead and install 
docker and docker-compose directly on your OS.  However, Docker filesystem interaction
is probably faster if you run it from a Linux VM as recommended for Windows hosts. 

USAGE OVERVIEW
==============
On a machine that is already configured with docker and docker-compose (see docker.com
and the internet in general for information on how to install them) you can run the
Bigfathom application stacks simply by doing this...

1. cd bigfathom_application/application_stack
2. ./createvolumes.sh
3. ./start.sh

That will create a running Bigfathom application server (localhost:55580) and a 
Phpmyadmin server (localhost:44480).  To shut down your stack, follow these
steps:

1. cd bigfathom_application/application_stack
2. ./stop.sh

You can restart the stack at anytime by launching just the start.sh script.
If you want to clear all the persisted memory (stored in docker volumes) run
the killvolumes.sh script and then re-run the createvolumes.sh script again.

Post your questions and insights at https://bigfathom.org

FOLDERS
=======
application_stack
-- This is where you go to launch a running Bigfathom application
appserver_image
-- This is where we build the appserver that runs in the stack

