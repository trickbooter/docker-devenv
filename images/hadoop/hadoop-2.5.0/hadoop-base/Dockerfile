FROM trickbooter/basebuild
MAINTAINER trickbooter (paul@trickbooter.com)

# CREDIT Yongbok Kim <ruo91@yongbok.net>
# CREDIT SequenceIQ

ENV TERM linux

RUN apt-get update
RUN apt-get install -y rsync

# Setup Passwordless SSH cert
RUN cd /root && ssh-keygen -t dsa -P '' -f "/root/.ssh/id_dsa" && \
    cat /root/.ssh/id_dsa.pub >> /root/.ssh/authorized_keys && \
    chmod 644 /root/.ssh/authorized_keys
    
# Configure SSH
ADD ssh-config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config

# Apache Hadoop Common Env (a lot relies on this, don't change unless you know what you are doing)
ENV SRC_DIR /usr/local
ENV HADOOP_VERSION 2.5.0
ENV HADOOP_PREFIX ${SRC_DIR}/hadoop
ENV HADOOP_HOME ${HADOOP_PREFIX}
ENV HADOOP_MAPRED_HOME ${HADOOP_PREFIX}
ENV HADOOP_COMMON_HOME ${HADOOP_PREFIX}
ENV HADOOP_HDFS_HOME ${HADOOP_PREFIX}
ENV YARN_HOME ${HADOOP_PREFIX}
ENV HADOOP_CONF_DIR ${HADOOP_PREFIX}/etc/hadoop
ENV HADOOP_COMMON_LIB_NATIVE_DIR ${HADOOP_HOME}/lib/native
ENV HADOOP_OPTS -Djava.library.path=${HADOOP_COMMON_LIB_NATIVE_DIR} -Djava.net.preferIPv4Stack=true

ENV PATH $PATH:${HADOOP_PREFIX}/bin:${HADOOP_PREFIX}/sbin

# Get Apache Hadoop
RUN cd ${SRC_DIR} && \
    wget http://apache.mirror.serversaustralia.com.au/hadoop/common/stable/hadoop-${HADOOP_VERSION}.tar.gz
RUN cd ${SRC_DIR} && \
    tar xzvf hadoop-${HADOOP_VERSION}.tar.gz && \
    ln -s hadoop-${HADOOP_VERSION} ${HADOOP_PREFIX} &&\
    rm -Rf hadoop-${HADOOP_VERSION}.tar.gz

# Edit Hadoop JAVA_HOME
RUN sed -i "/^export JAVA_HOME/ s:.*:export JAVA_HOME=${JAVA_HOME}:" ${HADOOP_PREFIX}/etc/hadoop/hadoop-env.sh
RUN sed -i "/^export HADOOP_HOME/ s:.*:export HADOOP_HOME=${HADOOP_PREFIX}:" ${HADOOP_PREFIX}/etc/hadoop/hadoop-env.sh
RUN sed -i "/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=${HADOOP_CONF_DIR}:" ${HADOOP_PREFIX}/etc/hadoop/hadoop-env.sh

# Native Libraries
# Note, these are build from the Dockerfile hadoop-build
RUN rm ${HADOOP_PREFIX}/lib/native/*
RUN cd ${SRC_DIR} && \ 
    wget http://dl.bintray.com/trickbooter/generic/hadoop-native-libs-x64-${HADOOP_VERSION}.tar.gz && \
    tar xzvf hadoop-native-libs-x64-${HADOOP_VERSION}.tar.gz -C ${HADOOP_PREFIX}/lib/native
RUN cd ${SRC_DIR} && rm -f hadoop-native-libs-x64-${HADOOP_VERSION}.tar.gz

VOLUME [ "${HADOOP_HOME}/logs" ]