FROM trickbooter/basebuild
MAINTAINER trickbooter (paul@trickbooter.com)

ENV HB_VER 0.98.5

# Get and unpack Hbase
RUN cd /usr/local && wget http://apache.mirror.serversaustralia.com.au/hbase/stable/hbase-${HB_VER}-hadoop2-bin.tar.gz
RUN cd /usr/local && tar xzf hbase-${HB_VER}.tar.gz
RUN rm /usr/local/hbase-${HB_VER}.tar.gz
RUN ln -s /usr/local/hbase-${HB_VER} /usr/local/hbase

# Configuration
ADD conf/zoo.cfg /usr/local/zookeeper/conf/zoo.cfg
ADD conf/log4j.properties /usr/local/zookeeper/conf/log4j.properties

# Helpers

# Supervisor
ADD etc/supervisor/conf.d/zookeeper.conf /etc/supervisor/conf.d/zookeeper.conf


VOLUME [ "/zookeeper/data" ]
VOLUME [ "/zookeeper/logs" ]

EXPOSE 2181
