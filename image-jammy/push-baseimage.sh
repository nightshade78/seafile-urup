#!/bin/bash
source config
docker login
docker push nightshade78/seafile-urup-baseimage:${SEAFILE_VERSION}-${UBUNTU_VERSION}-${BASEIMAGE_BUILD}
docker push nightshade78/seafile-urup-baseimage:${UBUNTU_VERSION}-latest
docker logout
