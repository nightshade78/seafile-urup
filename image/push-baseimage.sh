#!/bin/bash
source config
docker login
docker push nightshade78/seafile-urup-baseimage:${SEAFILE_VERSION}-${BASEIMAGE_BUILD}
docker push nightshade78/seafile-urup-baseimage:latest
docker logout
