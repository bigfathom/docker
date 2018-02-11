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

If you on a Windows machine --- install Virtualbox 5.x first; then install
an UBUNTU16.x image VM and THEN install docker and docker-compose into that
VM.  Don't use Docker directly from a Windows host, you will have a bad time.

If you are on an OSX machine --- you can probably go ahead and install 
docker and docker-compose directly on your OS.  However, Docker filesystem interaction
is probably faster if you run it from a Linux VM as recommended for Windows hosts. 
