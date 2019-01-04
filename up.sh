#!/bin/bash

readonly name=ported # name of the service
readonly dir=/porter/mapped-ids

if [[ ! -d ${dir} ]]; then
  echo "ERROR"
  echo "The ${name} service cannot see ${dir}"
  exit 1
fi

# - - - - - - - - - - - - - - - - - - - - -
set -e

rackup             \
  --env production \
  --host 0.0.0.0   \
  --port 4547      \
  --server thin    \
  --warn           \
    config.ru
