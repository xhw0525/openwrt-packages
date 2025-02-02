#!/bin/sh

DEVICE_IDX=0
LOG_LEVEL=2
while getopts u:x:l: flag
do
    case "${flag}" in
        u) TOKEN=${OPTARG};;
        x) DEVICE_IDX=${OPTARG};;
        l) LOG_LEVEL=${OPTARG};;
    esac
done

if [ -z "${TOKEN}" ]; then
  echo "the token is empty, get token from https://www.ddnsto.com/ "
  exit 2
fi

echo "ddnsto version device_id is is:"
/usr/sbin/ddnsto -u ${TOKEN} -w

_term() {
  killall ddnsto 2>/dev/null
  exit
}

trap "_term;" SIGTERM

while true ; do
  if ! pidof "ddnsto" > /dev/null ; then
    echo "ddnsto try running"
    /usr/sbin/ddnsto -u ${TOKEN} -x ${DEVICE_IDX} &
    PID=$!
    wait $PID
    RET=$?
    echo "EXIT CODE: ${RET}"
    if [ "${RET}" == "100" ]; then
      echo "token error, please set a correct token from https://www.ddnsto.com/ "
      exit 100
    fi
  fi
  sleep 20
done

