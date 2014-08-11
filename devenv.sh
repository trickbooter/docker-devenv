#!/bin/bash

# devenv up - exists? up else fetch+up
# devenv update - fetch+up
# devenv down - tear down

# git checkout
# 

function usage() {
  echo "Usage: $0 [up|update|destroy]"
  exit 1
}

function up() {
  echo "up x"
  # git checkout docker-devenv
  # 
  # 
  # 
}

function update() {
  echo "update"
}

function destroy() {
  echo "destroy"
}

[[ $# -eq 0 ]] && usage

$1