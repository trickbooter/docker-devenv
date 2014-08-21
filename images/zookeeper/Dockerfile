FROM trickbooter/oracle-java7
MAINTAINER trickbooter (paul@trickbooter.com)

RUN apt-get update
RUN apt-get install -y git curl build-essential make gcc wget

ENV ZK_VER 3.4.6

# Get and unpack Zookeeper
RUN cd /usr/local && wget http://apache.mirror.serversaustralia.com.au/zookeeper/current/zookeeper-$ZK_VER.tar.gz
RUN cd /usr/local && tar xzf zookeeper-$ZK_VER.tar.gz
RUN rm /usr/local/zookeeper-"$ZK_VER".tar.gz
RUN ln -s /usr/local/zookeeper-$ZK_VER /usr/local/zookeeper

ADD zoo.cfg /usr/local/zookeeper/conf/zoo.cfg
ADD log4j.properties /usr/local/zookeeper/conf/log4j.properties
ADD bootstrap /usr/local/zookeeper/bootstrap
RUN chmod +x /usr/local/zookeeper/bootstrap

VOLUME [ "/zookeeper/data" ]
VOLUME [ "/zookeeper/logs" ]

EXPOSE 2181

# CMD ["/usr/local/zookeeper/bootstrap"]
CMD ["/usr/local/zookeeper/bin/zkServer.sh",  "start-foreground"]