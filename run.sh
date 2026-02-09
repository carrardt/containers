#!/usr/bin/bash

[ "$SUDOCMD" != "" ] || SUDOCMD="sudo"
echo "sudo command is ${SUDOCMD}"

[ $CONTAINERNAME ] || CONTAINERNAME="ubuntu-custom"
[ $CONTAINERUSER ] || CONTAINERUSER="$USER"

[ $HOSTNAME ] || HOSTNAME=`hostname`
[ $DOCKERFILEDIR ] || DOCKERFILEDIR=`pwd`
echo "*** Container ${CONTAINERNAME} running on $HOSTNAME (DIR=$DOCKERFILEDIR) ***"

[ $DOCKER ] || DOCKER=`which docker`
[ ! $DOCKER ] && echo "Installing docker.io ..." && ${SUDOCMD} apt install docker.io && DOCKER=`which docker`
[ ! $DOCKER ] && echo "Failed to find docker, aborting" && exit 1

# Ensures we have a home/workdir for our container
CONTAINERHOME=$HOME/containers/$CONTAINERNAME
mkdir -p $CONTAINERHOME
echo "*** Container parameters : home=${CONTAINERHOME} , user=${CONTAINERUSER} ***"

# build docker image if not present
DOCKERBUILT=` ${SUDOCMD} $DOCKER images | grep -c "${CONTAINERNAME}.*latest"`
[ $DOCKERBUILT -eq 0 ] && echo "Building ${CONTAINERNAME} docker image ..." &&  ${SUDOCMD} ${DOCKER} build --build-arg USERNAME=${CONTAINERUSER} -t ${CONTAINERNAME} ${DOCKERFILEDIR}
DOCKERBUILT=` ${SUDOCMD} $DOCKER images | grep -c "${CONTAINERNAME}.*latest"`
[ $DOCKERBUILT -eq 0 ] && echo "Failed to build docker image, aborting" && exit 1

[ $XHOST ] || XHOST=`which xhost`
[ ! $XHOST ] && echo "Installing x11-xserver-utils ..." &&  ${SUDOCMD} apt install x11-xserver-utils && XHOST=`which xhost`
[ ! $XHOST ] && echo "Can't find xhost, aborting" && exit 1
${XHOST} +

# Run container
${SUDOCMD} ${DOCKER} run --network=host --interactive \
                -v /tmp/.X11-unix:/tmp/.X11-unix -v /tmp/.X11-unix:/tmp/.X11-unix \
                -v ${CONTAINERHOME}:/home/${CONTAINERUSER}  -v $HOME/.Xauthority:/home/${CONTAINERUSER}/.Xauthority \
                -e DISPLAY=${DISPLAY} -h $HOSTNAME ${CONTAINERNAME}

