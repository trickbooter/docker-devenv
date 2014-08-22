#/bin/bash
set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"
APPS=${APPS:-/mnt/apps}

killz(){
	echo "Killing all docker containers:"
	docker ps
	ids=`docker ps | tail -n +2 | cut -d ' ' -f 1`
	echo $ids | xargs docker kill
	echo $ids | xargs docker rm
}

stop(){
	echo "Stopping all docker containers:"
	docker ps
	ids=`docker ps | tail -n +2 | cut -d ' ' -f 1`
	echo $ids | xargs docker stop
	echo $ids | xargs docker rm
}

start(){

	APP_DATA=${APP_DATA:=/home/${USER}/docked}
	mkdir -p ${APP_DATA}

	# Note, this is a Jeff Lindsay project
	# Determine default Host IP
	HOST_IP="$(ip ro | grep $(ip ro | grep 'default' | awk '{print $5}') | grep 'src' | awk '{print $9'})"
	echo "Host IP detected as ${HOST_IP}"
	
	# Determine Docker0 brdige IP
	DOCKER_BRIDGE_IP="$(ip ro | grep 'docker0' | awk '{print $9}')"
	echo "Docker0 bridge IP detected as ${DOCKER_BRIDGE_IP}"
	
	DNS="8.8.8.8"
	
	# Start up Consul server
	docker rm -f consul > /dev/null 2>&1 | true
	CONSUL=$(docker run \
		  -d \
		  -p ${HOST_IP}:8300:8300 \
		  -p ${HOST_IP}:8301:8301 \
		  -p ${HOST_IP}:8301:8301/udp \
		  -p ${HOST_IP}:8302:8302 \
		  -p ${HOST_IP}:8302:8302/udp \
		  -p ${HOST_IP}:8400:8400 \
		  -p ${HOST_IP}:8500:8500 \
		  -p ${DOCKER_BRIDGE_IP}:53:53/udp \
		  --name consul \
		  -h ${HOSTNAME} \
		  progrium/consul -server -advertise ${HOST_IP} -bootstrap)
	echo "Started CONSUL in container ${CONSUL}"
	
	# Start up Zookeeper server
	mkdir -p ${APP_DATA}/zookeeper/data
	mkdir -p ${APP_DATA}/zookeeper/logs
	docker rm -f zookeeper > /dev/null 2>&1 | true 
	ZOOKEEPER=$(docker run \
		-d \
		-p 2181:2181 \
		-v ${APP_DATA}/zookeeper/logs:/zookeeper/logs \
		-e HOST_IP=${HOST_IP} \
		--dns=${DOCKER_BRIDGE_IP} \
		--dns=${DNS} \
		--dns-search=consul \
		--name zookeeper \
		-h zookeeper \
		trickbooter/zookeeper:3.4.6)
	echo "Started ZOOKEEPER in container ${ZOOKEEPER}"

	# Start up Cassandra
	mkdir -p ${APP_DATA}/cassandra/data
	mkdir -p ${APP_DATA}/cassandra/logs
	docker rm -f cassandra > /dev/null 2>&1 | true 
	CASSANDRA=$(docker run \
		-d \
		-p 7000:7000 \
		-p 7001:7001 \
		-p 7199:7199 \
		-p 9160:9160 \
		-p 9042:9042 \
		-v $APP_DATA/cassandra/data:/data \
		-v $APP_DATA/cassandra/logs:/logs \
		-e HOST_IP=$HOST_IP \
		--dns=${DOCKER_BRIDGE_IP} \
		--dns=${DNS} \
		--dns-search=consul \
		--name cassandra \
		-h cassandra \
		trickbooter/cassandra:2.0.9)
	echo "Started CASSANDRA in container $CASSANDRA"
	
	# Start up Kafka
	mkdir -p $APP_DATA/kafka/data
	mkdir -p $APP_DATA/kafka/logs
	docker rm -f kafka > /dev/null 2>&1 | true 
	KAFKA=$(docker run \
		-d \
		-p 9092:9092 \
		-v $APP_DATA/kafka/data:/kafka/data \
		-v $APP_DATA/kafka/logs:/kafka/logs \
		-e HOST_IP=${HOST_IP} \
		--dns=${DOCKER_BRIDGE_IP} \
		--dns=${DNS} \
		--dns-search=consul \
		--name kafka \
		-h kafka \
		trickbooter/kafka:0.8.1.1)
	echo "Started KAFKA in container $KAFKA"
	
	exit

	SHIPYARD=$(docker run \
		-d \
		-p 8005:8000 \
		shipyard/shipyard)
		
	#mkdir -p $APPS/elasticsearch/data
	#mkdir -p $APPS/elasticsearch/logs
	#ELASTICSEARCH=$(docker run \
	#	-d \
	#	-p 9200:9200 \
	#	-p 9300:9300 \
	#	-v $APPS/elasticsearch/data:/data \
	#	-v $APPS/elasticsearch/logs:/logs \
	#	trickbooter/elasticsearch)
	#echo "Started ELASTICSEARCH in container $ELASTICSEARCH"

	sleep 1

}

update(){
	apt-get update
	apt-get install -y lxc-docker
	cp /vagrant/etc/docker.conf /etc/init/docker.conf

	docker pull trickbooter/zookeeper
	docker pull trickbooter/redis
	docker pull trickbooter/cassandra
	docker pull trickbooter/elasticsearch
	docker pull trickbooter/mongo
	docker pull trickbooter/kafka
	docker pull shipyard/shipyard
}

case "$1" in
	restart)
		killz
		start
		;;
	start)
		start
		;;
	stop)
		stop
		;;
	kill)
		killz
		;;
	update)
		update
		;;
	status)
		docker ps
		;;
	*)
		echo $"Usage: $0 {start|stop|kill|update|restart|status|ssh}"
		RETVAL=1
esac
