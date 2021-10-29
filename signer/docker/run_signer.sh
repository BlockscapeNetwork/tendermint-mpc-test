#!/bin/bash

mkdir -p /data

#overwrite existing files in data
if [[ ${OVERWRITE} -gt 0 ]]
then
  echo "The variable is greater than 0. Delete Signer files in /data"
  rm -rf /data/*
else
  echo "The variable is 0. Do not delete signer files"
fi

#check if /data contains data
DIR=/data/shares
if [ -d "$DIR" ]; then
    echo "$DIR exists."
else
    echo "$DIR does not exist. copy files and overwrite"
    cp -R /configure/config/* /data
fi

cd /data/

sed -E -i 's+key_file = \".*\"+key_file = \"'/data/shares/${SIGNER}/share.json'\"+' config.toml
sed -E -i 's+chain_id = \".*\"+chain_id = \"'${CHAINID}'\"+' config.toml
sed -i 's/cosigner_threshold = 2/cosigner_threshold = '${cosigner_threshold}'/' config.toml
sed -E -i 's+cosigner_listen_address = \".*\"+cosigner_listen_address = \"'${cosigner_listen_address}'\"+' config.toml
sed -i 's/id = x/id = '${COSIGNERID1}'/' config.toml
sed -E -i 's+remote_address = "tcp://2.2.2.2:1234"+remote_address = \"'${COSIGNER1REMOTEADDR}'\"+' config.toml
sed -i 's/id = y/id = '${COSIGNERID2}'/' config.toml
sed -E -i 's+remote_address = "tcp://3.3.3.3:1234"+remote_address = \"'${COSIGNER2REMOTEADDR}'\"+' config.toml
sed -E -i 's+address = "tcp://<node-a ip>:1234"+address = \"'${VALIDATOR1}'\"+' config.toml
sed -E -i 's+address = "tcp://<node-b ip>:1234"+address = \"'${VALIDATOR2}'\"+' config.toml

#check if priv_validator_state.json exists
FILE=/data/${CHAINID}_share_sign_state.json
if [ -f "$FILE" ]; then
    echo "$FILE exists."
else
    echo "$FILE does not exist. copy files and overwrite"
    cp -R /configure/state-json/priv_validator_state.json .
    mv priv_validator_state.json ${CHAINID}_share_sign_state.json
fi

signer --config /data/config.toml