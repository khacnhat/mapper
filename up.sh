#!/bin/bash

readonly dir=/porter/mapped-ids

if [[ ! -d ${dir} ]]; then
  echo "INFO"
  echo "The mapper service cannot see ${dir}"
  echo "and is assuming there has been no port of"
  echo "old-architecture storer to new-architecture saver"
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
