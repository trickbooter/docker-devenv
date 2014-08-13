#!/bin/bash

# Protobuf
cd ~
# Get Protobuf Source
curl -# -O https://protobuf.googlecode.com/files/protobuf-2.5.0.tar.gz 
# Unpack it
gunzip protobuf-2.5.0.tar.gz
tar -xvf protobuf-2.5.0.tar
cd protobuf-2.5.0
# Set build prefix
./configure --prefix=/usr
# Make source
make
# Make source installer
make install
# Check Version 2.5
protoc --version
cd java
# install protobuf
mvn install
# package protobuf
mvn package

# Hadoop Build
cd ~
# Download Hadoop
wget http://apache.mirror.serversaustralia.com.au/hadoop/common/current/hadoop-2.4.1-src.tar.gz
# Unpack it
tar zxf hadoop-2.4.1-src.tar.gz
cd hadoop-2.4.1-src
# Build it
mvn clean install -DskipTests
# Package it
mvn package -Dmaven.javadoc.skip=true -Pdist,native -DskipTests=true -Dtar

# Tar native libs
cd hadoop-dist/target/hadoop-2.4.1/lib/native
tar cfvz hadoop-native-libs.tar.gz *

# If our host has mounted a data directory, copy our libs to it
if [ -d "/data" ]; then
  mv hadoop-native-libs.tar.gz /data
fi