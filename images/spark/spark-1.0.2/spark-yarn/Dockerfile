FROM trickbooter/hadoop-pseudo:2.5.0
MAINTAINER trickbooter <paul@trickbooter.com>

ENV SCALA_VERSION 2.10.4
ENV SPARK_VERSION 1.0.2
ENV SCALA_HOME /usr/local/scala-${SCALA_VERSION}
ENV SPARK_HOME /usr/local/spark/spark-${SPARK_VERSION}
ENV PATH ${SPARK_HOME}:${SCALA_HOME}/bin:${PATH}

# Install Scala
RUN cd /usr/local && \
    wget http://www.scala-lang.org/files/archive/scala-${SCALA_VERSION}.tgz && \
    tar -xvzf scala-${SCALA_VERSION}.tgz && \
    ln -s spark-v1.0.1-rc2 spark && \
    rm scala-${SCALA_VERSION}.tgz

# Install Spark 
    
ADD http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop2.tgz /
RUN (cd / && gunzip < spark-${SPARK_VERSION}-bin-hadoop1.tgz)|(cd /usr/local/spark && tar -xvf -) && \
    (ln -s /usr/local/spark/spark-${SPARK_VERSION}-bin-hadoop1 /usr/local/spark/spark-$SPARK_VERSION && rm /spark-${SPARK_VERSION}-bin-hadoop1.tgz)

# Add Config
ADD hadoop/etc/hadoop/core-site.xml ${HADOOP_CONF_DIR}/core-site.xml
ADD hadoop/etc/hadoop/yarn-site.xml ${HADOOP_CONF_DIR}/yarn-site.xml

# Create s spark symbolic link
RUN cd /usr/local && ln -s spark-v1.0.1-rc2 spark

# Copy files onto HDFS
RUN service sshd start && ${HADOOP_PREFIX}/etc/hadoop/hadoop-env.sh && ${HADOOP_PREFIX}/sbin/start-dfs.sh && ${HADOOP_PREFIX}/bin/hdfs dfs -put /usr/local/spark/assembly/target/scala-2.10 /spark
# Shut it down (supervisor will spin it up later)
RUN ${HADOOP_PREFIX}/etc/hadoop/hadoop-env.sh && ${HADOOP_PREFIX}/sbin/stop-dfs.sh && service sshd stop

# Set spark environment variable
ENV SPARK_JAR hdfs:///spark/spark-assembly-1.0.1-hadoop2.4.1.jar
