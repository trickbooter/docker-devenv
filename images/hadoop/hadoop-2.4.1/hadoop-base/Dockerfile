FROM trickbooter/oracle-java7
MAINTAINER trickbooter (paul@trickbooter.com)

# CREDIT Yongbok Kim <ruo91@yongbok.net>
# CREDITE SequenceIQ

ENV TERM linux

RUN apt-get update
RUN apt-get install -y rsync tar wget

# Apache Hadoop Common Env
ENV SRC_DIR /usr/local
ENV HADOOP_VERSION hadoop-2.4.1
ENV HADOOP_PREFIX $SRC_DIR/hadoop
ENV HADOOP_HOME $HADOOP_PREFIX
ENV HADOOP_MAPRED_HOME $HADOOP_PREFIX
ENV HADOOP_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV HADOOP_COMMON_HOME $HADOOP_PREFIX
ENV HADOOP_HDFS_HOME $HADOOP_PREFIX
ENV HADOOP_COMMON_LIB_NATIVE_DIR $HADOOP_HOME/lib/native
ENV HADOOP_OPTS -Djava.library.path=$HADOOP_COMMON_LIB_NATIVE_DIR -Djava.net.preferIPv4Stack=true
ENV YARN_HOME $HADOOP_PREFIX
ENV PATH $PATH:$HADOOP_PREFIX/bin:$HADOOP_PREFIX/sbin

# Get Apache Hadoop
RUN cd $SRC_DIR && \
    wget http://apache.mirror.serversaustralia.com.au/hadoop/common/current/$HADOOP_VERSION.tar.gz
RUN cd $SRC_DIR && \
    tar xzvf $HADOOP_VERSION.tar.gz && \
    mv $HADOOP_VERSION $HADOOP_PREFIX &&\
    rm -Rf $HADOOP_VERSION.tar.gz

# Echo to profile
RUN echo '' >> /etc/profile && \
    echo '# JDK' >> /etc/profile && \
    echo "export JAVA_HOME=$JAVA_HOME" >> /etc/profile && \
    echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile && \
    echo '' >> /etc/profile

# Echo to profile
RUN echo '# Hadoop' >> /etc/profile
RUN echo "export HADOOP_PREFIX=$HADOOP_PREFIX" >> /etc/profile
RUN echo "export HADOOP_HOME=$HADOOP_PREFIX" >> /etc/profile
RUN echo 'export HADOOP_MAPRED_HOME=$HADOOP_PREFIX' >> /etc/profile
RUN echo 'export HADOOP_COMMON_HOME=$HADOOP_PREFIX' >> /etc/profile
RUN echo 'export HADOOP_HDFS_HOME=$HADOOP_PREFIX' >> /etc/profile
RUN echo 'export YARN_HOME=$HADOOP_PREFIX' >> /etc/profile
RUN echo 'export PATH=$PATH' >> /etc/profile

# Edit Hadoop JAVA_HOME
RUN sed -i "/^export JAVA_HOME/ s:.*:export JAVA_HOME=$JAVA_HOME:" $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
RUN sed -i "/^export HADOOP_HOME/ s:.*:export HADOOP_HOME=$HADOOP_PREFIX:" $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
RUN sed -i "/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=$HADOOP_CONF_DIR:" $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

# Native Libraries
# Note, these are build from the Dockerfile hadoop-build
RUN rm $HADOOP_PREFIX/lib/native/*
RUN cd $SRC_DIR && \ 
    wget http://dl.bintray.com/trickbooter/generic/hadoop-native-libs-x64-2.4.1.tar.gz && \
    tar xzvf hadoop-native-libs-x64-2.4.1.tar.gz -C $HADOOP_PREFIX/lib/native
RUN cd $SRC_DIR && rm -f hadoop-native-libs-x64-2.4.1.tar.gz
