#!/bin/bash

SCRIPT_HOME="$( cd "$( dirname "$0" )" && pwd )"

for dir in $SCRIPT_HOME/../images/*/
do
	cd $dir &&
	image_name=${PWD##*/} && # to assign to a variable
	echo "Pushing $image_name" &&
	docker push relateiq/$image_name
done
