FROM trickbooter/oracle-java7

RUN apt-get update
RUN apt-get install -y git curl build-essential make gcc wget

RUN wget http://apache.mirror.serversaustralia.com.au/zookeeper/current/zookeeper-3.4.6.tar.gz
RUN tar xzf zookeeper-3.4.6.tar.gz

ADD zoo.cfg /zookeeper-3.4.6/conf/zoo.cfg
ADD log4j.properties /zookeeper-3.4.6/conf/log4j.properties

VOLUME [ "/data" ]
VOLUME [ "/logs" ]

EXPOSE 2181

CMD ["zookeeper-3.4.6/bin/zkServer.sh", "start-foreground"]

