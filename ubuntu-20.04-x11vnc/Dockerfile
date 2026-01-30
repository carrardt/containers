# Use the official image as a parent image
FROM ubuntu:20.04

# Update the system
RUN apt update 

# edit to match you local timezone
RUN DEBIAN_FRONTEND="noninteractive" TZ="Europe/Paris" apt install -y tzdata
RUN apt upgrade -y

# install base packages
RUN apt install -y sudo x11-apps mesa-utils xterm xvfb x11vnc fluxbox remmina 

# install development packages
# RUN apt install -y g++ gcc cmake git libyaml-cpp-dev mpi-default-dev

# create user and group
ARG USERNAME=johndoe
RUN addgroup $USERNAME
RUN adduser --home /home/$USERNAME --ingroup $USERNAME --disabled-password --gecos "" $USERNAME
RUN adduser $USERNAME sudo
RUN echo "$USERNAME:$USERNAME" | chpasswd
RUN chown -R $USERNAME:$USERNAME /home/$USERNAME

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# run as user
USER $USERNAME
ENV HOME /home/$USERNAME
ENV LIBGL_ALWAYS_SOFTWARE 1
ENV QT_GRAPHICSSYSTEM native
WORKDIR /home/$USERNAME

# X11 virtual frame buffer and vnc startup script
ADD --chown=root:root ./start-x11-vnc.sh /usr/bin/

# Run graphical terminal app from container with display forwared to host
CMD [ "/usr/bin/xterm" ]
#CMD /usr/bin/bash /usr/bin/start-x11-vnc.sh

