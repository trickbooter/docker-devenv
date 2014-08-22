docker-hadoop-build
===================

## Build Apache Hadoop
Hadoop native libraries are included for 32 bit archtiectures. We have to rebuild Hadoop to get native libraries suitable for the architecture of the target platform. 
This takes 30 minutes, and deals with dependencies (Java, Protobuf).

This Docker image contains the build process of Hadoop 2.4.1 nativelibs.

## Build the image
```
docker build -t trickbooter/hadoop-nativelibs:2.4.1 .
```

## Run the container
```
docker run -it --name hadoop-build trickbooter/hadoop-nativelibs:2.4.1 .
```

## Send the files to bintray
docker run -e BINTRAY_USER=[Bintray Username] -e BINTRAY_KEY=[Bintray API Key] -name hadoop-build trickbooter/hadoop-nativelibs:2.4.1 /tmp/push-to-bintray.sh