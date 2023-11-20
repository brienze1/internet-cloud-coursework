#!/bin/bash

echo "-----------------Script-02----------------- [whiteboard-api]"

echo "########### Cloudformation Start ###########"
aws cloudformation deploy \
 --stack-name whiteboard-api \
 --template-file "/cloudformation/whiteboard-api.yaml" \
 --endpoint-url http://localstack:4566
