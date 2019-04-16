#!/usr/bin/env bash

#docker run -d --shm-size=1g -p 1521:1521 -p 8080:8000 alexeiled/docker-oracle-xe-11g

docker run -d --shm-size=1g -p 1521:1521 -e ORACLE_ALLOW_REMOTE=true  oracleinanutshell/oracle-xe-11g
