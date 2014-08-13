FROM trickbooter/oracle-java7
MAINTAINER trickbooter (paul@trickbooter.com)

# Docker to build Native Hadoop libraries on an approporiate platform

RUN apt-get update
RUN apt-get install -y gcc g++ curl make maven cmake zlibc zlib1g zlib1g-dev libcurl4-openssl-dev snappy libbz2-dev

# maven
RUN curl http://www.eu.apache.org/dist/maven/maven-3/3.2.1/binaries/apache-maven-3.2.1-bin.tar.gz|tar xz  -C /usr/share
ENV M2_HOME /usr/share/apache-maven-3.2.1
ENV PATH $PATH:$M2_HOME/bin

# hadoop
RUN curl http://www.eu.apache.org/dist/hadoop/common/hadoop-2.4.1/hadoop-2.4.1-src.tar.gz | tar -xz -C /tmp/

# protoc -ohhh
RUN curl https://protobuf.googlecode.com/files/protobuf-2.5.0.tar.bz2 | bunzip2|tar -x -C /tmp
RUN cd /tmp/protobuf-2.5.0 && ./configure
RUN cd /tmp/protobuf-2.5.0 && make && make install
ENV LD_LIBRARY_PATH /usr/local/lib
ENV LD_RUN_PATH /usr/local/lib

# build native libs
RUN cd /tmp/hadoop-2.4.1-src && mvn package -Dmaven.javadoc.skip=true -Pdist,native -DskipTests=true -Dtar

# tar native libs
RUN cd /tmp/hadoop-2.4.1-src/hadoop-dist/target/hadoop-2.4.1/lib/native && tar cfvz /tmp/hadoop-native-libs-x64-2.4.1.tar.gz *

# Stub env vars
ENV BINTRAY_USER unknown
ENV BINTRAY_KEY unknown

# get bintray helper (using SequenceIQ's bintray functions)
RUN curl -Lo /tmp/bintray-functions j.mp/bintray-functions

# Add the bootstrap file
ADD push-to-bintray.sh /tmp/push-to-bintray.sh
RUN chmod +x /tmp/push-to-bintray.sh