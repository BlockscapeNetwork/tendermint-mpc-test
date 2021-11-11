#!/bin/bash

#overwrite existing files in data
if [[ ${OVERWRITE} -gt 0 ]]
then
  echo "The variable is greater than 0. Overwrite Chain files in /data"
  mkdir -p /data
  cp -R /configure/config /data
else
  echo "The variable is 0. Do not delete chain files"
fi


cd /data/config/config


sed -E -i 's/persistent_peers = \".*\"/persistent_peers = \"'${PERSISTENTPEERS}'\"/' config.toml


echo "${NODEKEYJSON}" > node_key.json

junod start --rpc.laddr tcp://0.0.0.0:26657 --trace --priv_validator_laddr tcp://0.0.0.0:${PRIVPORT} --home /data/config