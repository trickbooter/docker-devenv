FROM trickbooter/oracle-java7
MAINTAINER trickbooter (paul@trickbooter.com)

# CREDIT Yongbok Kim <ruo91@yongbok.net>

ENV TERM linux

RUN apt-get update
RUN apt-get install -y rsync ssh tar wget

# Apache Hadoop
ENV SRC_DIR /opt
ENV HADOOP_VERSION hadoop-2.4.1
RUN cd $SRC_DIR && \
    wget http://apache.mirror.serversaustralia.com.au/hadoop/common/current/$HADOOP_VERSION.tar.gz && \
    tar xzvf $HADOOP_VERSION.tar.gz
RUN cd $SRC_DIR && rm -f $HADOOP_VERSION.tar.gz

RUN echo '' >> /etc/profile \
RUN echo '# JDK' >> /etc/profile \
RUN echo "export JAVA_HOME=$JAVA_HOME" >> /etc/profile \
RUN echo 'export PATH=$PATH:$JAVA_HOME/bin' >> /etc/profile \
RUN echo '' >> /etc/profile

# Hadoop ENV
ENV HADOOP_PREFIX $SRC_DIR/$HADOOP_VERSION
ENV PATH $PATH:$HADOOP_PREFIX/bin:$HADOOP_PREFIX/sbin
ENV HADOOP_MAPRED_HOME $HADOOP_PREFIX
ENV HADOOP_COMMON_HOME $HADOOP_PREFIX
ENV HADOOP_HDFS_HOME $HADOOP_PREFIX
ENV YARN_HOME $HADOOP_PREFIX
RUN echo '# Hadoop' >> /etc/profile
RUN echo "export HADOOP_PREFIX=$SRC_DIR/$HADOOP_VERSION" >> /etc/profile
RUN echo 'export PATH=$PATH:$HADOOP_PREFIX/bin:$HADOOP_PREFIX/sbin' >> /etc/profile
RUN echo 'export HADOOP_MAPRED_HOME=$HADOOP_PREFIX' >> /etc/profile
RUN echo 'export HADOOP_COMMON_HOME=$HADOOP_PREFIX' >> /etc/profile
RUN echo 'export HADOOP_HDFS_HOME=$HADOOP_PREFIX' >> /etc/profile
RUN echo 'export YARN_HOME=$HADOOP_PREFIX' >> /etc/profile

# Add in the etc/hadoop directory
ADD conf/core-site.xml $HADOOP_PREFIX/etc/hadoop/core-site.xml
ADD conf/hdfs-site.xml $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
ADD conf/yarn-site.xml $HADOOP_PREFIX/etc/hadoop/yarn-site.xml
ADD conf/mapred-site.xml $HADOOP_PREFIX/etc/hadoop/mapred-site.xml
RUN sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr/local/jdk:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

# Native
# https://gist.github.com/ruo91/7154697#comment-936487
RUN echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_PREFIX/lib/native' >> $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
RUN echo 'export HADOOP_OPTS=-Djava.library.path=$HADOOP_PREFIX/lib' >> $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
RUN echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_PREFIX/lib/native' >> $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
RUN echo 'export HADOOP_OPTS=-Djava.library.path=$HADOOP_PREFIX/lib' >> $HADOOP_PREFIX/etc/hadoop/yarn-env.sh

# SSH keygen
RUN cd /root && ssh-keygen -t dsa -P '' -f "/root/.ssh/id_dsa" \
 && cat /root/.ssh/id_dsa.pub >> /root/.ssh/authorized_keys && chmod 644 /root/.ssh/authorized_keys

# Name node foramt
RUN hdfs namenode -format

# Supervisor
RUN mkdir -p /var/log/supervisor
ADD conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# SSH
RUN mkdir /var/run/sshd
RUN sed -i 's/without-password/yes/g' /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
RUN echo 'SSHD: ALL' >> /etc/hosts.allow

# Root password
RUN echo 'root:hadoop' |chpasswd

# Port
EXPOSE 22 8030 8031 8032 8033 8040 8042 8088 9000 50010 50020 50070 50075 50090

# Daemon
CMD ["/usr/bin/supervisord"]