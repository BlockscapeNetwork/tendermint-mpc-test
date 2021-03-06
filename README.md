# MPC local Test with docker-compose and juno-uni-1 testnet

versions:

Juno binary
```
name: juno
server_name: junod
version: HEAD-e507450f2e20aa4017e046bd24a7d8f1d3ca437a
commit: e507450f2e20aa4017e046bd24a7d8f1d3ca437a
build_tags: netgo,ledger
go: go version go1.17 darwin/amd64
```


Tendermint-mpc binary commit:

```
e4a1fa93e05681e9aa4e8419795d1f268e06b049
```

## Create signer bin

```
git clone https://gitlab.com/unit410/tendermint-validator

cd tendermint-validator

git checkout e4a1fa93e05681e9aa4e8419795d1f268e06b049

go mod tidy

env GOOS=linux GOARCH=amd64 make build
```

copy binary to this Repository \<project-dir>/signer/bin

example:

`cp tendermint-validator/build/* tendermint-mpc-test/signer/bin`


## Create validator bin

```
git clone https://github.com/CosmosContracts/juno

cd juno

git checkout e507450f2e20aa4017e046bd24a7d8f1d3ca437a

env GOOS=linux GOARCH=amd64 make build
```

example:

`cp juno/bin/junod tendermint-mpc-test/validator/bin`

## Build validator image

in this project dir:

`docker build -t validator:v0.0.1 validator --no-cache`

## Run validator image locally (optional)

`docker run --env-file envval.list validator:v0.0.1`

## Create shares

`key2shares --total 3 --threshold 2 priv_validator_key.json (or other location of priv_validator_key.json)`

rename private_share_1.json to share.json and copy to <this-project-dir/signer/config/shares/1/share.json>
rename private_share_2.json to share.json and copy to <this-project-dir/signer/config/shares/2/share.json>
rename private_share_3.json to share.json and copy to <this-project-dir/signer/config/shares/3/share.json>

## Build signer image

in this project dir:

`docker build -t signer:v0.0.1 signer --no-cache`

## Run signer image locally (optional)

`docker run --env-file envsigner.list signer:v0.0.1`


## Important information

docker-compose file tries to attach your lokal ~/.juno and ~/.juno2 (second val) folder to start at synced blocked height (you should store this chaindata there)

to create ~/.juno2 with chain data. You can copy ~/.juno files to ~/.juno2 `cp -R ~/.juno ~/.juno2` (please stop your local daemon before copy)

if you want to use data in validator image for ~/.juno and ~/.juno2 set OVERWRITE=1 for both validators in docker-compose.yml. (pay attention. this overwrites data in ~/.juno and ~/.juno2 with the data in validator/config (docker image) and starts syncing around Block 0)

### Start docker-compose

`docker-compose up`


### cmds

```
docker logs tendermint-mpc-test-validator1-1 -f

docker logs tendermint-mpc-test-validator2-1 -f


docker logs tendermint-mpc-test-signer1-1 -f

docker logs tendermint-mpc-test-signer2-1 -f

docker logs tendermint-mpc-test-signer3-1 -f
```


## Watch status

val1:`curl localhost:30057/status`

val2:`curl localhost:30157/status`


## Check current signer logs for =SIGNED_MSG_TYPE_

in project dir.

`docker-compose stop signer1` (or other signer: ex. signer2, signer3)

in this test case I stopped signer1 with "=SIGNED_MSG_TYPE_" logs:

signer3 throws error:

`GetEphemeralSecretPart req error` and the two remaining signer shows some weird behavior where some blocks are signed and some not.

Expected behaviour: 100% signing

Ticket here: `https://gitlab.com/unit410/tendermint-validator/-/issues/2`

## if you need to create val

`junod tx staking create-validator --amount 1000000ujunox --node tcp://localhost:30057 --keyring-backend test --chain-id uni --fees 500ujunox --from Wallet --node-id bc1909ad9b5f1f08a5d9506ee9376d27672721de --moniker test-bl --pubkey '{"@type":"/cosmos.crypto.ed25519.PubKey","key":"\<key\>"}' --commission-max-change-rate 0.01 --commission-max-rate 0.3999 --commission-rate 0.0999 --min-self-delegation 1`