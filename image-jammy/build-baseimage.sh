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

PROJECT=nightshade78/seafile-urup-baseimage

source config

cd baseimage

echoc ${BLUE} "Cleaning up build directory from old generated files..."
if [ -e "generated" ]; then
  rm -rf generated/seafile-server-*
else
  mkdir generated
fi
if [ -e "Dockerfile" ]; then
  rm -f Dockerfile
fi
if [ -e "Dockerfile.gen" ]; then
  rm -f Dockerfile.gen
fi
echook

echoc ${BLUE} "Downloading required artifacts..."
wget -c -O generated/seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz "https://s3.eu-central-1.amazonaws.com/download.seadrive.org/seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz"
echook

echoc ${BLUE} "Extracting required artifacts..."
tar -xzf generated/seafile-server_${SEAFILE_VERSION}_x86-64.tar.gz -C generated/
echook

echoc ${BLUE} "Applying non-root hotfix to seafile for also serving static content..."
sed -i "s;media_url = settings.MEDIA_URL.strip('/');## --- Static serve media fix, original code:\n    ##media_url = settings.MEDIA_URL.strip('/')\n    ## --- new code\n    media_url = settings.MEDIA_URL\n    site_root = settings.SITE_ROOT\n    if media_url.startswith(site_root):\n        media_url = media_url[len(site_root):]\n    media_url = media_url.strip('/')\n    ## --- end new code;g" generated/seafile-server-${SEAFILE_VERSION}/seahub/seahub/urls.py
echook

echoc ${BLUE} "Generating Dockerfile from template..."
sed -e "s/UBTVERARG/${UBUNTU_VERSION}/g" -e "s/SFLVERARG/${SEAFILE_VERSION}/g" Dockerfile.tpl > Dockerfile
echook

FULLPATH=${PROJECT}:${SEAFILE_VERSION}-${UBUNTU_VERSION}-${BASEIMAGE_BUILD}
echoc ${BLUE} "Building image [$FULLPATH]..."
docker build --pull --rm -t $FULLPATH .
echook

echoc ${BLUE} "Tagging image as latest..."
docker tag $FULLPATH ${PROJECT}:${UBUNTU_VERSION}-latest
echook

mv Dockerfile Dockerfile.gen

cd ..

echoc ${BLUE} "Done."
