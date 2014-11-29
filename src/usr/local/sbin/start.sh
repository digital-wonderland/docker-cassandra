#! /usr/bin/env bash

# Fail hard and fast
set -eo pipefail

if [ -z "$CASSANDRA_CONFIG_BROADCAST_ADDRESS" ]; then
  echo "\$CASSANDRA_CONFIG_BROADCAST_ADDRESS not set"
  exit 1
fi
echo "CASSANDRA_CONFIG_BROADCAST_ADDRESS=$CASSANDRA_CONFIG_BROADCAST_ADDRESS"

CASSANDRA_CONFIG_LISTEN_INTERFACE=${CASSANDRA_CONFIG_LISTEN_INTERFACE:-"eth0"}
export CASSANDRA_CONFIG_LISTEN_INTERFACE

CASSANDRA_CONFIG_RPC_ADDRESS=${CASSANDRA_CONFIG_RPC_ADDRESS:-"0.0.0.0"}
export CASSANDRA_CONFIG_RPC_ADDRESS

CASSANDRA_CONFIG_BROADCAST_RPC_ADDRESS=${CASSANDRA_CONFIG_BROADCAST_RPC_ADDRESS:-$CASSANDRA_CONFIG_BROADCAST_ADDRESS}
export CASSANDRA_CONFIG_BROADCAST_RPC_ADDRESS

CASSANDRA_CONFIG_SEEDS=${CASSANDRA_CONFIG_SEEDS:-\"$CASSANDRA_CONFIG_BROADCAST_ADDRESS\"}
export CASSANDRA_CONFIG_SEEDS

sed -i 's/^listen_address:/# listen_address:/g' $CASSANDRA_CONF/cassandra.yaml

# General config
for VAR in `env`
do
  if [[ $VAR =~ ^CASSANDRA_CONFIG_ && ! $VAR =~ ^KAFKA_HOME ]]; then
    CASSANDRA_CONFIG_VAR=`echo "$VAR" | sed -r "s/CASSANDRA_CONFIG_(.*)=.*/\1/g" | tr '[:upper:]' '[:lower:]'`
    CASSANDRA_ENV_VAR=`echo "$VAR" | sed -r "s/(.*)=.*/\1/g"`

    if egrep -q "(^|^#\s+|\s+)$CASSANDRA_CONFIG_VAR:" $CASSANDRA_CONF/cassandra.yaml; then
      sed -r -i "s/(^|#\s)(\s+-\s)?$CASSANDRA_CONFIG_VAR:.*$/\2$CASSANDRA_CONFIG_VAR: ${!CASSANDRA_ENV_VAR}/g" $CASSANDRA_CONF/cassandra.yaml
    else
      echo "$CASSANDRA_CONFIG_VAR: ${!CASSANDRA_ENV_VAR}" >> $CASSANDRA_CONF/cassandra.yaml
    fi
  fi
done

su cassandra -s /bin/bash -c 'cassandra -f'
