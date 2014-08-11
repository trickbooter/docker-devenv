FROM trickbooter/oracle-java7
MAINTAINER trickbooter (paul@trickbooter.com)

RUN apt-get update
RUN apt-get install -y git curl build-essential make gcc wget

# Install Cassandra
RUN cd /opt && wget http://apache.mirror.serversaustralia.com.au/kafka/0.8.1.1/kafka_2.10-0.8.1.1.tgz
RUN cd /opt && tar xzvf kafka_*.tgz
RUN rm /opt/*.tgz
RUN mv /opt/kafka_* /opt/kafka

RUN mkdir /data && mkdir /logs

ADD server.properties /opt/kafka/config/server.properties
ADD kafka-start.sh /opt/kafka/kafka-start.sh

ENV JMX_PORT 7203

VOLUME [ "/data" ]
VOLUME [ "/logs" ]

# primary
EXPOSE 9092
# jmx
EXPOSE 7203

CMD ["/opt/kafka/kafka-start.sh"]
