#!/bin/bash


if [[ -z ADMIN_USER_TOKEN ]] ; then
  echo "ERROR: ADMIN_USER_TOKEN env variable is undefined"
  exit 1
fi

if [[ -z LICENSED_USER_TOKEN ]] ; then
  echo "ERROR: LICENSED_USER_TOKEN env variable is undefined"
  exit 1
fi

cd "$(dirname "$0")"

echo "** Test simple access control"
kubectl apply -f ../src/manifests/private-app.yaml > /dev/null
kubectl apply -f ../src/manifests/admin-app.yaml > /dev/null
kubectl apply -f ../tutorials/3-access-control/simple/ > /dev/null
kubectl wait -n traefik-hub --for=jsonpath='{status.urls}' apigateway/api-gateway
# Sleep is needed to wait for CRD being applied
sleep 3
go test -run AccessControlSimple -args -url=$(kubectl get apigateway api-gateway -o template --template '{{ .status.urls }}')
kubectl delete -f ../tutorials/3-access-control/simple/ > /dev/null

echo "** Test advanced access control"
kubectl apply -f ../tutorials/3-access-control/complex/ > /dev/null
kubectl wait -n traefik-hub --for=jsonpath='{status.urls}' apigateway/api-gateway
# Sleep is needed to wait for CRD being applied
sleep 3
go test -run AccessControlAdvanced -args -url=$(kubectl get apigateway api-gateway -o template --template '{{ .status.urls }}')
kubectl delete -f ../tutorials/3-access-control/complex/ > /dev/null

