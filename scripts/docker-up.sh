#!/bin/bash

docker-compose -f build/docker-compose.yml down --volumes

#docker-compose -f build/docker-compose.yml build --no-cache

docker-compose -f build/docker-compose.yml up