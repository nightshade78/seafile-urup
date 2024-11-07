#!/bin/bash
source config
docker login -u nightshade78
docker push nightshade78/seafile-urup-baseimage:${SEAFILE_VERSION}-${BASEIMAGE_BUILD}
docker push nightshade78/seafile-urup-baseimage:latest
docker logout
