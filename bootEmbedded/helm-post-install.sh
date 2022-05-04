#!/bin/bash

/galasa/kubectl get svc api-external -o=jsonpath='{.spec.ports[?(@.name=="http")].nodePort}'