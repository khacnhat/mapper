#!/bin/bash
set -e

wait_until_ready()
{
  local name="${1}"
  local port="${2}"
  local method="${3}"
  local max_tries=20
  local cmd="curl --silent --fail --data '{}' -X GET http://localhost:${port}/${method}"
  cmd+=" > /dev/null 2>&1"

  if [ ! -z ${DOCKER_MACHINE_NAME} ]; then
    cmd="docker-machine ssh ${DOCKER_MACHINE_NAME} ${cmd}"
  fi
  echo -n "Waiting until ${name} is ready"
  for _ in $(seq ${max_tries})
  do
    echo -n '.'
    if eval ${cmd} ; then
      echo 'OK'
      return
    else
      sleep 0.1
    fi
  done
  echo 'FAIL'
  echo "${name} not ready after ${max_tries} tries"
  docker logs ${name}
  exit 1
}

# - - - - - - - - - - - - - - - - - - -

wait_until_up()
{
  local name="${1}"
  local n=20
  while [ $(( n -= 1 )) -ge 0 ]
  do
    if docker ps --filter status=running --format '{{.Names}}' | grep -q ^${name}$ ; then
      return
    else
      sleep 0.1
    fi
  done
  echo "${name} not up after 20 tries"
  docker logs "${name}"
  exit 1
}

# - - - - - - - - - - - - - - - - - - -

exit_unless_clean()
{
  # This test for empty docker-logs relies on the rack server
  # not syncing stdout. If sync is on/true then you get 3 lines:
  #    Thin web server (v1.7.2 codename Bachmanity)
  #    Maximum connections set to 1024
  #    Listening on 0.0.0.0:4517, CTRL+C to stop
  local name="${1}"
  local docker_logs=$(docker logs "${name}")
  echo -n "Checking ${name} started cleanly..."
  if [[ -z "${docker_logs}" ]]; then
    echo 'OK'
  else
    echo 'FAIL'
    echo "[docker logs ${name}] not empty on startup"
    echo "<docker_logs>"
    echo "${docker_logs}"
    echo "</docker_logs>"
    exit 1
  fi
}

# - - - - - - - - - - - - - - - - - - - -

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

docker-compose \
  --file "${ROOT_DIR}/docker-compose.yml" \
  up \
  -d \
  --force-recreate

readonly MY_NAME=mapper

wait_until_ready "test-${MY_NAME}-server" 4547 ready
exit_unless_clean "test-${MY_NAME}-server"
wait_until_up "test-${MY_NAME}-client"
