#!/bin/bash
docker stop memcache
docker rm memcache
docker run -d --name memcache --restart=unless-stopped memcached:latest memcached -m 2048
