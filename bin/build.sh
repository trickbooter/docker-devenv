#!/bin/sh

if [ -n "$1" ]
then
  docker rmi -f trickbooter/$1
  echo ""
  docker build -t trickbooter/$1 $1/
fi