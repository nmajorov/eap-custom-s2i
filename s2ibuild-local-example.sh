#!/bin/env bash

echo "clean up previously created images"
docker rmi rh-eap72-app
docker rmi  majorov.biz/eap72

echo "build new s2i image"
docker build -t majorov.biz/eap72 .

echo "Generate with XA datasource"
#-e SCRIPT_DEBUG=true
s2i build -e DB_SERVICE_PREFIX_MAPPING=TODO-oracle=DB -e DB_DRIVER_NAME=oracle -e DB_USERNAME=system \
-e DB_PASSWORD=oracle -e  DB_JNDI=java:jboss/datasources/TodoListDS  \
-e DB_MIN_POOL_SIZE=1  -e DB_MAX_POOL_SIZE=2 \
-e  DB_XA_CONNECTION_PROPERTY_URL=jdbc:oracle:thin:@localhost:1521:XE \
  https://github.com/nmajorov/html5-frontend-sso.git \
  majorov.biz/eap72  rh-eap72-app
