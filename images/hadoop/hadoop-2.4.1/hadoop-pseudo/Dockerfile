FROM trickbooter/hadoop-base:2.4.1
MAINTAINER trickbooter (paul@trickbooter.com)

RUN apt-get install -y openssh-server openssh-client rsync

# Setup Passwordless SSH cert
RUN cd /root && ssh-keygen -t dsa -P '' -f "/root/.ssh/id_dsa" && \
    cat /root/.ssh/id_dsa.pub >> /root/.ssh/authorized_keys && \
    chmod 644 /root/.ssh/authorized_keys
    
# Configure SSH
ADD ssh-config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config

# Pseudo distributed add files (overwriting hadoop defaults)
ADD core-site.xml.template $HADOOP_CONF_DIR/core-site.xml.template
ADD yarn-site.xml.template $HADOOP_CONF_DIR/yarn-site.xml.template
ADD hdfs-site.xml $HADOOP_CONF_DIR/hdfs-site.xml
ADD mapred-site.xml $HADOOP_CONF_DIR/mapred-site.xml

# Pseudo distributed inject config
RUN sed s/HOSTNAME/localhost/ $HADOOP_CONF_DIR/core-site.xml.template > $HADOOP_CONF_DIR/core-site.xml
RUN sed s/HADOOP_HOME/\$HADOOP_HOME/ $HADOOP_CONF_DIR/yarn-site.xml.template > $HADOOP_CONF_DIR/yarn-site.xml

# Get a reference to our bootstrap file
ENV BOOTSTRAP $HADOOP_PREFIX/bootstrap.sh

ADD bootstrap.sh $BOOTSTRAP
RUN chown root:root $BOOTSTRAP
RUN chmod 700 $BOOTSTRAP

# workingaround docker.io build error
RUN ls -la $HADOOP_PREFIX/etc/hadoop/*-env.sh
RUN chmod +x $HADOOP_PREFIX/etc/hadoop/*-env.sh
RUN ls -la $HADOOP_PREFIX/etc/hadoop/*-env.sh

# fix the 254 error code
RUN sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config
RUN echo "UsePAM no" >> /etc/ssh/sshd_config
RUN echo "Port 2122" >> /etc/ssh/sshd_config

RUN service ssh start && $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh && $HADOOP_PREFIX/sbin/start-dfs.sh && $HADOOP_PREFIX/bin/hdfs dfs -mkdir -p /user/root
RUN service ssh start && $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh && $HADOOP_PREFIX/sbin/start-dfs.sh && $HADOOP_PREFIX/bin/hdfs dfs -put $HADOOP_PREFIX/etc/hadoop/ input

CMD ["$BOOTSTRAP", "-d"]

# Port
EXPOSE 22 8030 8031 8032 8033 8040 8042 8088 9000 50010 50020 50070 50075 50090
