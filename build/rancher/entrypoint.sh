#!/bin/bash

# RANCHER 1
echo "########### Waiting rancher 1 to become healthy ###########"
until curl http://rancher1 -s; do
  sleep 5
done
echo "########### Rancher 1 is up ###########"
sleep 20

echo "########### Getting token for rancher 1 ###########"
TOKEN=$(curl -k -s 'https://rancher1/v3-public/localProviders/local?action=login' -H 'content-type: application/json' --data-binary '{"username":"admin","password":"password","ttl":0}' | jq -r .token)
sleep 5

echo "########### Authenticating rancher 1 ###########"
rancher login https://rancher1/v3 --token "$TOKEN" --skip-verify
sleep 5

echo "########### Deploying whiteboard-api on rancher 1 ###########"
rancher kubectl create -f /init-scripts/rancher-cli/eks/deployment.yml --server https://rancher1

echo "########### Adding HPA to whiteboard-api on rancher 1 ###########"
rancher kubectl create -f /init-scripts/rancher-cli/eks/hpa.yml --server https://rancher1

echo "########### Adding NodePort service to whiteboard-api on rancher 1 ###########"
rancher kubectl create -f /init-scripts/rancher-cli/eks/service.yml --server https://rancher1

# RANCHER 2
echo "########### Waiting rancher 2 to become healthy ###########"
until curl http://rancher2 -s; do
  sleep 5
done
echo "########### Rancher 2 is up ###########"

echo "########### Getting token for rancher 2 ###########"
TOKEN=$(curl -k -s 'https://rancher2/v3-public/localProviders/local?action=login' -H 'content-type: application/json' --data-binary '{"username":"admin","password":"password","ttl":0}' | jq -r .token)
sleep 5

echo "########### Authenticating rancher 2 ###########"
rancher login https://rancher2/v3 --token "$TOKEN" --skip-verify
sleep 5

echo "########### Deploying whiteboard-api on rancher 2 ###########"
rancher kubectl create -f /init-scripts/rancher-cli/eks/deployment.yml --server https://rancher2

echo "########### Adding HPA to whiteboard-api on rancher 2 ###########"
rancher kubectl create -f /init-scripts/rancher-cli/eks/hpa.yml --server https://rancher2

echo "########### Adding NodePort service to whiteboard-api on rancher 2 ###########"
rancher kubectl create -f /init-scripts/rancher-cli/eks/service.yml --server https://rancher2
