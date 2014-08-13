FROM trickbooter/oracle-java7
MAINTAINER trickbooter (paul@trickbooter.com)

# Docker to build Native Hadoop libraries on an approporiate platform

RUN apt-get update
RUN apt-get install -y gcc g++ curl make maven cmake zlibc zlib1g zlib1g-dev libcurl4-openssl-dev snappy libbz2-dev

ADD build-native-libs.sh /opt/build-native-libs.sh
ADD push-to-bintray.sh /opt/push-to-bintray.sh
RUN chmod +x /opt/build-native-libs.sh
RUN chmod +x /opt/push-to-bintray.sh



# get bintray helper
RUN curl -Lo /tmp/bintray-functions j.mp/bintray-functions && . /tmp/bintray-functions