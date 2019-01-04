#!/bin/bash

readonly name=ported # name of the service
readonly dir=porter
readonly uid=19664
readonly username=porter
readonly gid=65533
readonly group=nogroup
readonly vm_target=${DOCKER_MACHINE_NAME:-default}

if [[ ! -d /${dir} ]]; then
  cmd="mkdir /${dir}"
  echo "ERROR"
  echo "The ${name} service needs to volume-mount /${dir}"
  echo "Please run:"
  echo "  \$ [sudo] ${cmd}"
  echo "If you are running on Docker-Toolbox remember"
  echo "to run this on the target VM. For example:"
  echo "  \$ docker-machine ssh ${vm_target} sudo ${cmd}"
  exit 1
fi

# - - - - - - - - - - - - - - - - - - - - -
set -e

if [ ! -d /${dir}/mapped-ids ]; then
  mkdir /${dir}/mapped-ids
fi

rackup             \
  --env production \
  --host 0.0.0.0   \
  --port 4547      \
  --server thin    \
  --warn           \
    config.ru
