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

	# Note, this is a Jeff Lindsay project that I have forked
	# Determine Docker0 Bridge IP
	# CONSUL=$(docker run --rm trickbooter/consul cmd:run 127.0.0.1 -it)
	# echo "Started CONSUL in container $CONSUL"

	mkdir -p $APP_DATA/zookeeper/data
	mkdir -p $APP_DATA/zookeeper/logs
	docker rm -f zookeeper > /dev/null 2>&1 | true 
	ZOOKEEPER=$(docker run \
		-d \
		-p 2181:2181 \
		-v $APP_DATA/zookeeper/logs:/zookeeper/logs \
		--name zookeeper \
		-h zookeeper \
		trickbooter/zookeeper)
	echo "Started ZOOKEEPER in container $ZOOKEEPER"

	mkdir -p $APP_DATA/cassandra/data
	mkdir -p $APP_DATA/cassandra/logs
	CASSANDRA=$(docker run \
		-d \
		-p 7000:7000 \
		-p 7001:7001 \
		-p 7199:7199 \
		-p 9160:9160 \
		-p 9042:9042 \
		-v $APP_DATA/cassandra/data:/data \
		-v $APP_DATA/cassandra/logs:/logs \
		trickbooter/cassandra)
	echo "Started CASSANDRA in container $CASSANDRA"
	


	mkdir -p $APP_DATA/kafka/data
	mkdir -p $APP_DATA/kafka/logs
	sudo docker rm -f kafka > /dev/null 2>&1 | true 
	KAFKA=$(docker run \
		-d \
		-p 9092:9092 \
		-v $APP_DATA/kafka/data:/kafka/data \
		-v $APP_DATA/kafka/logs:/kafka/logs \
		--name kafka \
		--link zookeeper:zookeeper \
		trickbooter/kafka)
	echo "Started KAFKA in container $KAFKA"

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
