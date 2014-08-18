FROM ubuntu
MAINTAINER trickbooter <paul@trickbooter.com>

ENV TERM linux

# install base tools
RUN apt-get update -y
RUN apt-get install -y curl git tar unzip wget supervisor

ENV HOME /root

# supervisor installation && 
# create directory for child images to store configuration in
RUN mkdir -p /var/log/supervisor && \
    mkdir -p /etc/supervisor/conf.d

# supervisor base configuration
ADD supervisor.conf /etc/supervisor.conf

# default command
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]