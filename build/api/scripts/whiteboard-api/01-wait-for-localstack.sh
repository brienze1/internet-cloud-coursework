#!/bin/bash


echo "-----------------Script-01----------------- [whiteboard-api]"

echo "########### Check if localstack is up ###########"
until curl http://localstack:4566/health --silent; do
  sleep 1
done

echo "Localstack is up"