#!/bin/bash

# RANCHER 1
echo "########### Waiting rancher 1 to become healthy ###########"
until curl http://rancher1 -s; do
  sleep 5
done
echo "########### Rancher 1 is up ###########"

echo "########### Getting token for rancher 1 ###########"
TOKEN=$(curl -k -s 'https://rancher1/v3-public/localProviders/local?action=login' -H 'content-type: application/json' --data-binary '{"username":"admin","password":"password","ttl":0}' | jq -r .token)

echo "########### Authenticating rancher 1 ###########"
rancher login https://rancher1/v3 --token "$TOKEN" --skip-verify

echo "########### Deploying static-site on rancher 1 ###########"
rancher kubectl create deployment static-site --image prakhar1989/static-site --server https://rancher1

echo "########### Exposing static-site port 80 on rancher 1 ###########"
rancher kubectl expose deployment static-site --type=NodePort --port=80 --name=static-site-service --server https://rancher1

echo "########### Patching NodePort to port 30000 on rancher 1 ###########"
rancher kubectl patch service static-site-service --type='json' --patch='[{"op": "replace", "path": "/spec/ports/0/nodePort", "value":30000}]' --server https://rancher1

echo "########### Updating static-site replica number to 2 on rancher 1 ###########"
rancher kubectl scale deployment static-site --replicas=2 --server https://rancher1

# RANCHER 2
echo "########### Waiting rancher 2 to become healthy ###########"
until curl http://rancher2 -s; do
  sleep 5
done
echo "########### Rancher 2 is up ###########"

echo "########### Getting token for rancher 2 ###########"
TOKEN=$(curl -k -s 'https://rancher2/v3-public/localProviders/local?action=login' -H 'content-type: application/json' --data-binary '{"username":"admin","password":"password","ttl":0}' | jq -r .token)

echo "########### Authenticating rancher 2 ###########"
rancher login https://rancher2/v3 --token "$TOKEN" --skip-verify

echo "########### Deploying static-site on rancher 2 ###########"
rancher kubectl create deployment static-site --image prakhar1989/static-site --server https://rancher2

echo "########### Exposing static-site port 80 on rancher 2 ###########"
rancher kubectl expose deployment static-site --type=NodePort --port=80 --name=static-site-service --server https://rancher2

echo "########### Patching NodePort to port 30000 on rancher 2 ###########"
rancher kubectl patch service static-site-service --type='json' --patch='[{"op": "replace", "path": "/spec/ports/0/nodePort", "value":30000}]' --server https://rancher2

echo "########### Updating static-site replica number to 2 on rancher 2 ###########"
rancher kubectl scale deployment static-site --replicas=2 --server https://rancher2
