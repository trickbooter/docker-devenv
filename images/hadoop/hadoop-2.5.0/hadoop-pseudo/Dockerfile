FROM trickbooter/hadoop-base:2.5.0
MAINTAINER trickbooter <paul@trickbooter.com>

# Make our site directories
ENV YARN_DATA /yarn/data
ENV YARN_TMP ${YARN_DATA}/tmp
RUN mkdir -p ${YARN_DATA}/namenode && \
    mkdir -p ${YARN_DATA}/datanode  && \
    mkdir -p ${YARN_TMP} && \
    mkdir -p ${HADOOP_PREFIX}/logs

# Pseudo distributed add files (overwriting hadoop defaults)
ADD hadoop/etc/hadoop/core-site.xml ${HADOOP_CONF_DIR}/core-site.xml
ADD hadoop/etc/hadoop/yarn-site.xml ${HADOOP_CONF_DIR}/yarn-site.xml
ADD hadoop/etc/hadoop/hdfs-site.xml ${HADOOP_CONF_DIR}/hdfs-site.xml
ADD hadoop/etc/hadoop/mapred-site.xml ${HADOOP_CONF_DIR}/mapred-site.xml

# Pseudo distributed inject config (@ to allow for paths)
RUN sed -i s@HOSTNAME@localhost@ ${HADOOP_CONF_DIR}/core-site.xml 
RUN sed -i s@YARN_TMP@"$YARN_TMP"@ ${HADOOP_CONF_DIR}/core-site.xml 
RUN sed -i s@HADOOP_HOME@$HADOOP_HOME@ ${HADOOP_CONF_DIR}/yarn-site.xml

# Get a reference to our bootstrap file
ENV BOOTSTRAP ${HADOOP_PREFIX}/bootstrap.sh

ADD bootstrap.sh ${BOOTSTRAP}
RUN chown root:root ${BOOTSTRAP}
RUN chmod 700 ${BOOTSTRAP}

# workingaround docker.io build error
RUN ls -la ${HADOOP_PREFIX}/etc/hadoop/*-env.sh
RUN chmod +x ${HADOOP_PREFIX}/etc/hadoop/*-env.sh
RUN ls -la ${HADOOP_PREFIX}/etc/hadoop/*-env.sh

# fix the 254 error code
RUN sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config
RUN echo "UsePAM no" >> /etc/ssh/sshd_config
RUN echo "Port 2122" >> /etc/ssh/sshd_config

# security
RUN chown root:root ${HADOOP_PREFIX}/logs $YARN_DATA
RUN chmod 750 ${HADOOP_PREFIX}/logs $YARN_DATA

# prepare namenode
RUN ${HADOOP_PREFIX}/bin/hdfs namenode -format -force

# Add supervisor files
ADD etc/supervisor/conf.d/sshd.conf /etc/supervisor/conf.d/sshd.conf
ADD etc/supervisor/conf.d/hdfs.conf /etc/supervisor/conf.d/hdfs.conf
ADD etc/supervisor/conf.d/yarn.conf /etc/supervisor/conf.d/yarn.conf

# Add consul
ADD etc/consul.d/hadoop-mr.json /etc/consul.d/hadoop-mr.json
ADD etc/consul.d/hdfs.json /etc/consul.d/hdfs.json


#RUN service ssh start && ${HADOOP_PREFIX}/etc/hadoop/hadoop-env.sh && $HADOOP_PREFIX/sbin/start-dfs.sh && $HADOOP_PREFIX/bin/hdfs dfs -mkdir -p /user/root
#RUN service ssh start && ${HADOOP_PREFIX}/etc/hadoop/hadoop-env.sh && $HADOOP_PREFIX/sbin/start-dfs.sh && $HADOOP_PREFIX/bin/hdfs dfs -put $HADOOP_PREFIX/etc/hadoop/ input

#CMD ["${BOOTSTRAP}", "-d"]

# Port
EXPOSE 22 8030 8031 8032 8033 8040 8042 8088 9000 50010 50020 50070 50075 50090

#8088 Resource Manager
#9000 HDFS