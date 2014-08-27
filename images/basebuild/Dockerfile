# Base docker image for Ubuntu that sets up

FROM ubuntu:trusty
MAINTAINER paul@trickbooter.com

# Let aptitude know it's a non-interactive install
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

ENV HOME /root

# Don't let upstart start installed services
ADD usr/sbin/policy-rc.d /usr/sbin/policy-rc.d
RUN /bin/chmod 755 /usr/sbin/policy-rc.d

# Install dependencies
RUN \
  apt-get update && \
  apt-get install -y -q  build-essential \
                         curl \
                         git \
                         logrotate \
                         python-dev \
                         python-pip \
                         python-software-properties \
                         software-properties-common \
                         openssh-server \
                         openssh-client \
                         supervisor \
                         tar \
                         unzip \
                         wget && \
  apt-get clean
  
# Install python dependencies
RUN pip install passport

# Prepare Java package source
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && \
    apt-get update

# auto accept oracle jdk license
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java7-installer

ENV JAVA_HOME /usr/lib/jvm/java-7-oracle/
ENV PATH $PATH:$JAVA_HOME/bin

# Add the root .ssh files
RUN mkdir -m 0700 -p /root/.ssh
ADD ssh/id_rsa /root/.ssh/id_rsa 
ADD ssh/id_rsa.pub /root/.ssh/id_rsa.pub
ADD ssh/ssh_config /root/.ssh/config

RUN \
  chmod 0700 /root/.ssh/id_rsa  && \
  cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys && \
  mkdir /var/run/sshd && \
  rm -f /etc/cron.daily/standard

# Install consul
RUN \
  curl -o /tmp/consul.zip -L https://dl.bintray.com/mitchellh/consul/0.3.1_linux_amd64.zip && \
  unzip /tmp/consul.zip -d /tmp/ && \
  chmod +x /tmp/consul && \
  mv /tmp/consul /usr/local/bin/consul && \
  rm /tmp/consul.zip && \
  mkdir -p /etc/consul.d

# Remove auto-installed cron jobs
RUN rm /etc/cron.daily/apt \
       /etc/cron.daily/dpkg \
       /etc/cron.daily/passwd \
       /etc/cron.daily/upstart \
       /etc/cron.weekly/fstrim

# Configuration files
ADD etc/consul.d/consul.json /etc/consul.d/consul.json
ADD etc/security/limits.conf /etc/security/limits.conf
ADD etc/supervisor/supervisord.conf /etc/supervisor/supervisord.conf
ADD etc/supervisor/conf.d/consul.conf /etc/supervisor/conf.d/consul.conf
ADD etc/supervisor/conf.d/cron.conf /etc/supervisor/conf.d/cron.conf
ADD etc/supervisor/conf.d/rsyslog.conf /etc/supervisor/conf.d/rsyslog.conf
ADD etc/supervisor/conf.d/sshd.conf /etc/supervisor/conf.d/sshd.conf
ADD etc/sysctl.conf /etc/sysctl.conf

# For consul
ENV GOMAXPROCS 10

# For Supervisor
RUN mkdir -p /supervisor/logs

# Export the supervisor log directory
VOLUME ["/var/log/supervisor"]

# Run Supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]