#!/bin/bash

set -e

if [ -z "$1" ]
  then
    echo "Hostname is missing"
    exit 1
fi

HOSTNAME=$1

if [ -z "$2" ]
  then
    PREFIX=""
  else 
    PREFIX=$2
fi

echo HOSTNAME     is $HOSTNAME
echo PREFIX       is $PREFIX

APIPORT=$(kubectl get svc $PREFIX-api-external -o=jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
ETCDPORT=$(kubectl get svc $PREFIX-etcd-external -o=jsonpath='{.spec.ports[?(@.name=="client")].nodePort}')
COUCHDBPORT=$(kubectl get svc $PREFIX-couchdb-external -o=jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')

echo API     port is $APIPORT
echo ETCD    port is $ETCDPORT
echo COUCHDB port is $COUCHDBPORT

kubectl get configmap $PREFIX-bootstrap-file -o yaml > bootstrap.yaml

sed "s/etcd:http:\/\/etcd:2379/etcd:http:\/\/$HOSTNAME:$ETCDPORT/g" bootstrap.yaml > bootstrap-new.yaml

kubectl replace -f bootstrap-new.yaml

kubectl rollout restart deployment/$PREFIX-api

kubectl rollout status deployment/$PREFIX-api -w --timeout=3m

export GALASA_EXTERNAL_DYNAMICSTATUS_STORE=etcd:http://$HOSTNAME:$ETCDPORT
export GALASA_EXTERNAL_RESULTARCHIVE_STORE=couchdb:http://$HOSTNAME:$COUCHDBPORT
export GALASA_EXTERNAL_CREDENTIALS_STORE=etcd:http://$HOSTNAME:$ETCDPORT

echo DSS   is $GALASA_EXTERNAL_DYNAMICSTATUS_STORE
echo RAS   is $GALASA_EXTERNAL_RESULTARCHIVE_STORE
echo CREDS is $GALASA_EXTERNAL_CREDENTIALS_STORE

java -jar boot.jar --obr file:galasa.obr --bootstrap http://$PREFIX-api:8080/bootstrap --setupeco
