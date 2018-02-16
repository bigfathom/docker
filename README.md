WHAT IS THIS?
=============
Project for running the Bigfathom application as a Docker stack

WHAT IS BIGFATHOM?
==================
Bigfathom is an open-source application that helps people organize their thoughts
and collaborate with others on common goals.  More information about it 
can be found at its official website: https://bigfathom.org

![Bigfathom Logo](https://bigfathom.org/sites/default/files/bigfathom_arrows_logo_plus_title.png)

All Bigfathom application source code is available from Official repo at https://github.com/bigfathom/bigfathom_application

All Docker source code is available from the Official repo at https://github.com/bigfathom/docker 

WHAT IS DOCKER?
===============
Docker is a fantastic virtualization tool that makes it easier to run collections
of machines, and applications on those machines, on your computer.  You can learn
more about them at their official website: https://www.docker.com/

The official public Bigfathom Docker page is at https://hub.docker.com/r/bigfathom/application_d7/

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

Folder Name | Content Purpose
------------ | -------------
application_stack | This is where you go to launch a running Bigfathom application
appserver_image | This is where we build the appserver that runs in the stack

STACK COMPOSE FILE
==================
An example of launching Bigfathom in a Docker stack is to have a docker-compose.yml
(such as the one in the application_stack folder of the repo) that looks like
this one ...

```dockerfile

version: "3.2"

services:
  
  appserver:
      
    image: bigfathom/application_d7
    volumes:
      - web-files:/var/www/html:rw
      - bucket-files:/var/local/bigfathom-bucket:rw
    ports:
      - "55580:80"
    expose:
      - "80"
    command: "/var/machine-scripts/startup.sh INIT"
    networks:
      - bigfathom_net
      
  db:
      
    image: mysql
    restart: always
    volumes:
      - db-files:/var/lib/mysql:rw
      
    ports:
      - "43306:3306"    
    expose:
      - "3306"
    environment:
      MYSQL_ROOT_PASSWORD: apass2018
      MYSQL_DATABASE: bigfathom_preview
      MYSQL_USER: appuser
      MYSQL_PASSWORD: apass2018
    networks:
      - bigfathom_net

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    environment:
      - PMA_HOSTS=db
      - PMA_PORT=3306
    restart: always
    ports:
      - 44480:80
    volumes:
      - /sessions
    networks:
      - bigfathom_net
      
volumes:

  web-files:
    external:
      name: appserver_web_bigfathom_preview

  bucket-files:
    external:
      name: appserver_bucket_bigfathom_preview

  db-files:
    external:
      name: db_bigfathom_preview
      
networks:
  bigfathom_net:
    external: false


```

DOCKER VOLUMES
==============
The included docker-compose.yml references three volumes as external,
so be sure to create them before launching (otherwise you get helpful 
volume missing errors from Docker).

```bash
   docker volume create appserver_web_bigfathom_preview
   docker volume create appserver_bucket_bigfathom_preview
   docker volume create db_bigfathom_preview
```

There are helper scripts in the **application_stack** folder to help with this.

Script  | Purpose
---- | ------------
createvolumes.sh | Create volumes in Docker native volume management area.  (Call the **mgt-helpers/point-volumes.sh** afterward to point it into a different area with a symbolic link.)
kill-volumes.sh | Destroys the volumes.  Use this if you want to clear all your persisted data an start again.
mgt-helpers/chown-volumes.sh | Change the ownership of all files and folders in the volumes from the host OS perspective.

APPLICATIONS IN STACK
=====================
When you launch a stack like the one above, you can point your browser
to the URLs shown in the table here.

URL  | Application
---- | ------------
localhost:55580 | The Bigfathom application with login as admin/admin2017 and several other accounts such as janedoe and johndoe. The developer install sets their passwords as the account name with 2017 appended.
localhost:44480 | The phpmyadmin pointed at the bigfathom_preview database.  The login credentials are set in the docker-compose.yml file.  (appuser/apass2018)

