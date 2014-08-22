FROM trickbooter/basebuild
MAINTAINER trickbooter <paul@trickbooter.com>

ENV KAFKA_VER 0.8.1.1
ENV SCALA_VER 2.10

# Install Cassandra
RUN cd /usr/local && wget http://apache.mirror.serversaustralia.com.au/kafka/${KAFKA_VER}/kafka_${SCALA_VER}-${KAFKA_VER}.tgz
RUN cd /usr/local && tar xzvf kafka_${SCALA_VER}-${KAFKA_VER}.tgz
RUN rm /usr/local/kafka_${SCALA_VER}-${KAFKA_VER}.tgz
RUN ln -s /usr/local/kafka_${SCALA_VER}-${KAFKA_VER} /usr/local/kafka

RUN mkdir -p /kafka/data 
RUN mkdir -p /kafka/logs

# Add Config
ADD config/server.properties /opt/kafka/config/server.properties

# Add Helper
ADD kafka-start.sh /usr/local/kafka/kafka-start.sh

# Add Supervior
ADD etc/supervisor/conf.d/kafka.conf /etc/supervisor/conf.d/kafka.conf

VOLUME [ "/kafka/data" ]
VOLUME [ "/kafka/logs" ]

# jmx primary
EXPOSE 7203 9092
