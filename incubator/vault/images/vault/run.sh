#!/bin/sh
if [ -z ${VAULT_HTTPS_PORT} ]; then
  export VAULT_HTTPS_PORT=8200
fi

#if [ -z ${CONSUL_SERVICE_HOST} ]; then
#  export CONSUL_SERVICE_HOST="127.0.0.1"
#fi

#if [ -z ${CONSUL_SERVICE_PORT} ]; then
#  export CONSUL_HTTP_PORT=SOME_CONSUL_PORT
#else
  export CONSUL_SERVICE_PORT=${CONSUL_SERVICE_PORT}
#fi

if [ -z ${CONSUL_SCHEME} ]; then
  export CONSUL_SCHEME="http"
fi

#if [ -z ${CONSUL_TOKEN} ]; then
#  export CONSUL_TOKEN=""
#else
#  CONSUL_TOKEN=${CONSUL_TOKEN}
#fi

if [ ! -z "${VAULT_SSL_KEY}" ] &&  [ ! -z "${VAULT_SSL_CRT}" ]; then
  echo "${VAULT_SSL_KEY}" | sed -e 's/\"//g' | sed -e 's/^[ \t]*//g' | sed -e 's/[ \t]$//g' > /etc/vault/ssl/vault.key
  echo "${VAULT_SSL_CRT}" | sed -e 's/\"//g' | sed -e 's/^[ \t]*//g' | sed -e 's/[ \t]$//g' > /etc/vault/ssl/vault.crt
else
  openssl req -x509 -newkey rsa:2048 -nodes -keyout /etc/vault/ssl/vault.key -out /etc/vault/ssl/vault.crt -days 365 -subj "/CN=vault.kube-system.svc.cluster.local"
fi

export VAULT_IP=`hostname -i`

sed -i "s,%%CONSUL_HOST%%,$CONSUL_SERVICE_HOST,"   /etc/vault/config.json
sed -i "s,%%CONSUL_PORT%%,$CONSUL_SERVICE_PORT,"      /etc/vault/config.json
sed -i "s,%%CONSUL_SCHEME%%,$CONSUL_SCHEME,"       /etc/vault/config.json
#sed -i "s,%%CONSUL_TOKEN%%,$CONSUL_TOKEN,"         /etc/vault/config.json
sed -i "s,%%VAULT_IP%%,$VAULT_IP,"                 /etc/vault/config.json
sed -i "s,%%VAULT_HTTPS_PORT%%,$VAULT_HTTPS_PORT," /etc/vault/config.json

cmd="vault server -config=/etc/vault/config.json $@;"

if [ ! -z ${VAULT_DEBUG} ]; then
  ls -lR /etc/vault
  cat /etc/vault/ssl/vault.crt
  cat /etc/vault/config.json
  echo "${cmd}"
  sed -i "s,INFO,DEBUG," /etc/vault/config.json
fi

## Master stuff

master() {

  vault server -config=/etc/vault/config.json $@ &

  if [ ! -f cartera.txt ]; then

    export VAULT_SKIP_VERIFY=true

    export VAULT_ADDR="https://${VAULT_IP}:${VAULT_HTTPS_PORT}"

    vault init -address=${VAULT_ADDR} > cartera.txt

    export VAULT_TOKEN=`grep 'Initial Root Token:' ###/path_to/something.txt### | awk '{print $NF}'`

    vault unseal `grep 'Key 1:' cartera.txt | awk '{print $NF}'`
    vault unseal `grep 'Key 2:' cartera.txt | awk '{print $NF}'`
    vault unseal `grep 'Key 3:' cartera.txt | awk '{print $NF}'`

  fi

}

case "$1" in
  master)           master $@;;
  *)                exec vault server -config=/etc/vault/config.json $@;;
esac
