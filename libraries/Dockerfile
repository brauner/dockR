FROM busybox:latest

MAINTAINER Christian Brauner christianvanbrauner[at]gmail.com

RUN mkdir /home/docker \
&& mkdir /home/docker/R \
&& mkdir /home/docker/R-dev \
&& chown 1000:1000 /home/docker/R \
&& chown 1000:1000 /home/docker/R-dev

VOLUME ["/home/docker/R"]
# for devtools users
VOLUME ["/home/docker/R-dev"]
