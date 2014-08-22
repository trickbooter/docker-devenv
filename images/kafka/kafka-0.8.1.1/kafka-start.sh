#!/bin/bash

echo "Fixing hostname"
HOST=`hostname`
echo $HOST 
echo "127.0.0.1 $HOST" >> /etc/hosts

echo "ZOOKEEPER_IP=$ZOOKEEPER_IP"

echo "Fixing ZOOKEEPER_IP in server.properties"
sed -i "s/{{ZOOKEEPER_IP}}/${ZOOKEEPER_IP:-localhost}/g" /opt/kafka/config/server.properties

echo "Starting kafka"
/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties > /logs/kafka.log 2>&1
