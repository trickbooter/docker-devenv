FROM trickbooter/oracle-java7
MAINTAINER trickbooter (paul@trickbooter.com)

RUN apt-get update
RUN apt-get install -y git curl build-essential make gcc wget

RUN cd /opt && wget http://apache.mirror.serversaustralia.com.au/zookeeper/current/zookeeper-3.4.6.tar.gz
RUN cd /opt && tar xzf zookeeper-*.tar.gz
RUN rm /opt/*.tar.gz
RUN mv /opt/zookeeper-* /opt/zookeeper

ADD zoo.cfg /opt/zookeeper/conf/zoo.cfg
ADD log4j.properties /opt/zookeeper-*/conf/log4j.properties

VOLUME [ "/data" ]
VOLUME [ "/logs" ]

EXPOSE 2181

CMD ["/opt/zookeeper/bin/zkServer.sh", "start-foreground"]

