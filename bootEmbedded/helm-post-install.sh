#!/bin/bash

set -e

APIPORT=$(kubectl get svc api-external -o=jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
ETCDPORT=$(kubectl get svc etcd-external -o=jsonpath='{.spec.ports[?(@.name=="client")].nodePort}')
COUCHDBPORT=$(kubectl get svc couchdb-external -o=jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')

echo HOSTNAME     is $1
echo API     port is $APIPORT
echo ETCD    port is $ETCDPORT
echo COUCHDB port is $COUCHDBPORT

kubectl get configmap bootstrap-file -o yaml > bootstrap.yaml

sed "s/etcd:http:\/\/etcd:2379/etcd:http:\/\/$1:$ETCDPORT/g" bootstrap.yaml > bootstrap-new.yaml

kubectl replace -f bootstrap-new.yaml

kubectl rollout restart deployment/api

kubectl rollout status deployment/api -w --timeout=3m

export GALASA_EXTERNAL_DYNAMICSTATUS_STORE=etcd:http://$1:$ETCDPORT
export GALASA_EXTERNAL_RESULTARCHIVE_STORE=etcd:http://$1:$ETCDPORT
export GALASA_EXTERNAL_CREDENTIALS_STORE=couchdb:http://$1:$COUCHDBPORT

echo DSS   is $GALASA_EXTERNAL_DYNAMICSTATUS_STORE
echo RAS   is $GALASA_EXTERNAL_RESULTARCHIVE_STORE
echo CREDS is $GALASA_EXTERNAL_CREDENTIALS_STORE

java -jar boot.jar --obr file:galasa.obr --bootstrap http://api:8080/bootstrap --setupeco
