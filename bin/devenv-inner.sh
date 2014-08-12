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

	CONSUL=$(docker run \
		-d \
		-p 8400:8400 \
		-p 8500:8500 \
		-p 8600:53/udp \
		-h node1 \
		progrium/consul  \
		-server \
		-bootstrap
	)
	echo "Started CONSUL in container $CONSUL"

	mkdir -p $APPS/zookeeper/data
	mkdir -p $APPS/zookeeper/logs
	sudo docker rm -f zookeeper > /dev/null 2>&1 | true 
	ZOOKEEPER=$(docker run \
		-d \
		-p 2181:2181 \
		-v $APPS/zookeeper/logs:/logs \
		--name zookeeper \
		-h zookeeper \
		trickbooter/zookeeper)
	echo "Started ZOOKEEPER in container $ZOOKEEPER"

	mkdir -p $APPS/cassandra/data
	mkdir -p $APPS/cassandra/logs
	CASSANDRA=$(docker run \
		-d \
		-p 7000:7000 \
		-p 7001:7001 \
		-p 7199:7199 \
		-p 9160:9160 \
		-p 9042:9042 \
		-v $APPS/cassandra/data:/data \
		-v $APPS/cassandra/logs:/logs \
		relateiq/cassandra)
	echo "Started CASSANDRA in container $CASSANDRA"
	
	
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

	mkdir -p $APPS/kafka/data
	mkdir -p $APPS/kafka/logs
	sudo docker rm -f kafka > /dev/null 2>&1 | true 
	KAFKA=$(docker run \
		-d \
		-p 9092:9092 \
		-v $APPS/kafka/data:/data \
		-v $APPS/kafka/logs:/logs \
		--name kafka \
		--link zookeeper:zookeeper \
		relateiq/kafka)
	echo "Started KAFKA in container $KAFKA"

	SHIPYARD=$(docker run \
		-d \
		-p 8005:8000 \
		shipyard/shipyard)

	sleep 1

}

update(){
	apt-get update
	apt-get install -y lxc-docker
	cp /vagrant/etc/docker.conf /etc/init/docker.conf

	docker pull relateiq/zookeeper
	docker pull relateiq/redis
	docker pull relateiq/cassandra
	docker pull relateiq/elasticsearch
	docker pull relateiq/mongo
	docker pull relateiq/kafka
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
