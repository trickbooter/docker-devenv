FROM trickbooter:oracle-java7
MAINTAINER trickbooter (paul@trickbooter.com)

ENV TERM linux

# Prepare Consul
RUN cd /opt && wget https://dl.bintray.com/mitchellh/consul/*_linux_amd64.zip
RUN cd /opt && unzip *_linux_amd64.zip -d /opt/consul
RUN rm /opt/*.zip

# Prepare Supervisor
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]