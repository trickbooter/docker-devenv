FROM trickbooter/oracle-java7
MAINTAINER trickbooter (paul@trickbooter.com)

ENV TERM linux

# Prepare Consul
RUN cd /opt && wget https://dl.bintray.com/mitchellh/consul/0.3.1_linux_amd64.zip
RUN cd /opt && unzip 0.3.1_linux_amd64.zip -d /opt/consul
RUN rm /opt/0.3.1_linux_amd64.zip

ADD ./config /data/consul/config/
ONBUILD ADD ./config /data/consul/config/ # Inheriting images must supply a consule service config file

# Add the Consul supervisor file
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
