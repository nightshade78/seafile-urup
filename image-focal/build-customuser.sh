#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

echoc()
{
  COLOR=$1
  MESSAGE=$2
  echo -e "${COLOR}${MESSAGE}${NC}"
}

echook()
{
  echoc ${BLUE} "ok."
  echo ""
}

PROJECT=seafile-urup-customuser

source config

BASE_VERSION=${SEAFILE_VERSION}-${BASEIMAGE_BUILD}

cd customuser

echoc ${BLUE} "Cleaning up build directory from old generated files..."
if [ -e "Dockerfile" ]; then
  rm -f Dockerfile
fi
if [ -e "Dockerfile.gen" ]; then
  rm -f Dockerfile.gen
fi
echook

if [[ $TARGET_USER == "" || $TARGET_GROUP == "" ]] ;then
  echoc ${BLUE} "No target user or group defined, skipping creation of according image-internal user/group..."
  TARGET_UID=0
  TARGET_GID=0
else
  TARGET_UID=`id -u ${TARGET_USER}`
  TARGET_GID=`id -g ${TARGET_GROUP}`
  echoc ${BLUE} "Creating image-internal seafile:seafile with IDs ${TARGET_UID}:${TARGET_GID}"
fi

echoc ${BLUE} "Generating Dockerfile from template..."
sed -e "s/BASEVERARG/${BASE_VERSION}/g" -e "s/TGTUIDARG/${TARGET_UID}/g" -e "s/TGTGIDARG/${TARGET_GID}/g" Dockerfile.tpl > Dockerfile
echook

FULLPATH=${PROJECT}:${BASE_VERSION}.${CUSTOM_BUILD}
echoc ${BLUE} "Building image [$FULLPATH]..."
docker build --rm -t $FULLPATH .
echook

echoc ${BLUE} "Tagging image as latest..."
docker tag $FULLPATH ${PROJECT}:latest
echook

mv Dockerfile Dockerfile.gen

cd ..

echoc ${BLUE} "Done."
