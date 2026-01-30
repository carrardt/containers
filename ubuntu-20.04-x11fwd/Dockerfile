# Use the official image as a parent image
FROM ubuntu:20.04

# Update the system
RUN apt-get update 
# edit to match you local timzone
RUN DEBIAN_FRONTEND="noninteractive" TZ="Europe/Paris" apt install -y tzdata
RUN apt-get upgrade -y

# install needed packages
RUN apt-get install -y sudo x11-apps mesa-utils xterm  g++ gcc cmake git

# create user and group
ARG USERNAME=johndoe
RUN echo "adding user $USERNAME ..."
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

# Run graphical terminal app from container with display forwared to host
CMD [ "/usr/bin/xterm" ]

