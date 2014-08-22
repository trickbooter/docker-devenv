#!/bin/bash

# basebuild < path=basebuild, imagename=basebuild, tag=latest
# zookeeper/zookeeper-3.4.6|zookeeper|3.4.6 < path=zookeeper/zookeeper-3.4.6, imagename=zookeeper, tag=3.4.6
# zookeeper/zookeeper-3.4.6|zookeeper < path=zookeeper/zookeeper-3.4.6, imagename=zookeeper, tag=latest

CONTAINERS=( basebuild zookeeper,zookeeper/zookeeper-3.4.6,3.4.6 cassandra,cassandra/cassandra-2.0.9,2.0.9 kafka,kafka/kafka-0.8.1.1,0.8.1.1 )

for CONTAINER in "${CONTAINERS[@]}"
do

  # Extract the bits
  IMG_NAME="$(echo ${CONTAINER} | awk '{split($0,x,","); print x[1]}')"
  IMG_PATH="$(echo ${CONTAINER} | awk '{split($0,x,","); print x[2]}')"
  IMG_TAG="$(echo ${CONTAINER} | awk '{split($0,x,","); print x[3]}')"

  # Set the path to be the image name if there is no path set
  IMG_PATH="${IMG_PATH:=$IMG_NAME}"
  # Add a colon to the tag if we have one
  if [ -n $IMG_TAG ]; then IMG_TAG=":${IMG_TAG}"; fi
 
  echo "Building ${IMG_NAME}${IMG_TAG} from ${IMG_PATH}"
  docker build -t trickbooter/${IMG_NAME}${IMG_TAG} ${IMG_PATH}/
done