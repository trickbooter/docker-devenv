FROM trickbooter/basebuild
MAINTAINER trickbooter <paul@trickbooter.com>

RUN apt-get install -y lsof

ENV CASS_VER 2.0.9

RUN cd /usr/local && wget http://apache.mirror.serversaustralia.com.au/cassandra/${CASS_VER}/apache-cassandra-${CASS_VER}-bin.tar.gz
RUN cd /usr/local && tar zxf apache-cassandra-${CASS_VER}-bin.tar.gz
RUN rm /usr/local/apache-cassandra-${CASS_VER}-bin.tar.gz
RUN ln -s /usr/local/apache-cassandra-${CASS_VER} /usr/local/cassandra

ENV CASSANDRA_HOME /usr/local/cassandra

# Add configuration
ADD conf/cassandra.yaml /usr/local/cassandra/conf/cassandra.yaml
ADD conf/log4j-server.properties /usr/local/cassandra/conf/log4j-server.properties
ADD conf/cassandra-topology.properties /usr/local/cassandra/conf/cassandra-topology.properties

# Add helpers
ADD conf/cassandra-env.sh /usr/local/cassandra/conf/cassandra-env.sh
ADD bin/start.sh /usr/local/cassandra/bin/start.sh

# Add supervisor
ADD  etc/supervisor/conf.d/cassandra.conf /etc/supervisor/conf.d/cassandra.conf

RUN chmod 755 /usr/local/cassandra/bin/start.sh
RUN mkdir -p /cassandra/data
RUN mkdir -p /cassandra/logs
RUN mkdir -p /cassandra/init
RUN mkdir -p /cassandra/commitlog

VOLUME [ "/cassandra/init" ]
VOLUME [ "/cassandra/logs" ]
VOLUME [ "/cassandra/data" ]

EXPOSE 7000 7001 7199 9160 9042


