FROM ubuntu:latest
MAINTAINER trickbooter <paul@trickbooter.com>

ENV TERM linux

# install base tools
RUN apt-get update -y
RUN apt-get install -y curl git tar unzip wget supervisor

ENV HOME /root

# supervisor installation && 
# create directory for child images to store configuration in
RUN mkdir -p /supervisor/logs && \
    mkdir -p /etc/supervisor/conf.d

# Expose the supervisor logs
VOLUME ["/supervisor/logs"]
    
# supervisor base configuration
ADD supervisor.conf /etc/supervisor.conf

# default command
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]