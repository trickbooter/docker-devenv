FROM trickbooter/basebuild
MAINTAINER trickbooter (paul@trickbooter.com)

ENV ZK_VER 3.4.6

# Get and unpack Zookeeper
RUN cd /usr/local && wget http://apache.mirror.serversaustralia.com.au/zookeeper/current/zookeeper-${ZK_VER}.tar.gz
RUN cd /usr/local && tar xzf zookeeper-${ZK_VER}.tar.gz
RUN rm /usr/local/zookeeper-${ZK_VER}.tar.gz
RUN ln -s /usr/local/zookeeper-${ZK_VER} /usr/local/zookeeper

# Configuration
ADD conf/zoo.cfg /usr/local/zookeeper/conf/zoo.cfg
ADD conf/log4j.properties /usr/local/zookeeper/conf/log4j.properties

# Helpers

# Supervisor
ADD etc/supervisor/conf.d/zookeeper.conf /etc/supervisor/conf.d/zookeeper.conf

# Consul
ADD etc/consul.d/zookeeper.json /etc/consul.d/zookeeper.json

VOLUME [ "/zookeeper/data" ]
VOLUME [ "/zookeeper/logs" ]

EXPOSE 2181
