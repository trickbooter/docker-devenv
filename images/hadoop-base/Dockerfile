FROM trickbooter/oracle-java7
MAINTAINER trickbooter (paul@trickbooter.com)

ENV TERM linux

RUN apt-get update
RUN apt-get install -y rsync ssh tar

RUN cd /opt && wget http://apache.mirror.serversaustralia.com.au/hadoop/common/current/hadoop-2.4.1.tar.gz
RUN cd /opt && tar xzvf hadoop_*.tgz
RUN rm /opt/*.tgz
RUN mv /opt/hadoop-* /opt/hadoop

ENV HADOOP_PREFIX /opt/hadoop
