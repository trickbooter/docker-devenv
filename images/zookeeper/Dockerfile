FROM trickbooter/oracle-java7
MAINTAINER trickbooter (paul@trickbooter.com)

RUN apt-get update
RUN apt-get install -y git curl build-essential make gcc wget

ENV ZK_VER 3.4.6

ENV INSTALL_ROOT /usr/local

# Get and unpack Zookeeper
RUN cd $INSTALL_ROOT && wget http://apache.mirror.serversaustralia.com.au/zookeeper/current/zookeeper-$ZK_VER.tar.gz
RUN cd $INSTALL_ROOT && tar xzf zookeeper-$ZK_VER.tar.gz
RUN rm $INSTALL_ROOT/"$ZK_VER".tar.gz
RUN ln -s $INSTALL_ROOT/zookeeper-$ZK_VER $INSTALL_ROOT/zookeeper

ADD zoo.cfg $INSTALL_ROOT/zookeeper/conf/zoo.cfg
ADD log4j.properties $INSTALL_ROOT/zookeeper/conf/log4j.properties

VOLUME [ "/zookeeper/data" ]
VOLUME [ "/zookeeper/logs" ]

EXPOSE 2181

CMD ["$INSTALL_ROOT/zookeeper/bin/zkServer.sh", "start-foreground"]

