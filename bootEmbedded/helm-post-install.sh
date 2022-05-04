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
