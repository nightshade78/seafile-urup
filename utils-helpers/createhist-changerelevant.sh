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

#VERSIONS=(7.0.1 7.0.2 7.0.3 7.0.4 7.0.5 7.1.3 7.1.4 7.1.5 8.0.3 8.0.4 8.0.5 8.0.6 8.0.7 8.0.7-1 8.0.8 9.0.0 9.0.1 9.0.2 9.0.3 9.0.4 9.0.5 9.0.6 9.0.7 9.0.8 9.0.9 9.0.10 10.0.0 10.0.1 11.0.1 11.0.2 11.0.3 11.0.4 11.0.5 11.0.6 11.0.7 11.0.8 11.0.9)
VERSIONS=(11.0.3 11.0.4 11.0.5 11.0.6 11.0.7 11.0.8 11.0.9)

echoc ${BLUE} "Downloading required images..."
for VER in ${VERSIONS[*]}
do
  docker pull seafileltd/seafile-mc:${VER}
done
echook

echoc ${BLUE} "Extracting change-relevant from images..."
for VER in ${VERSIONS[*]}
do
  mkdir -p changerelevant-${VER}/opt/seafile/seafile-server/seahub/seahub
  mkdir -p changerelevant-${VER}/usr/sbin
  mkdir -p changerelevant-${VER}/etc
  TMPCONTAINERID=$(docker create seafileltd/seafile-mc:${VER})
  docker cp $TMPCONTAINERID:/scripts changerelevant-${VER}
  docker cp $TMPCONTAINERID:/opt/seafile/seafile-server-${VER}/seahub/seahub/urls.py changerelevant-${VER}/opt/seafile/seafile-server/seahub/seahub/urls.py
  docker cp $TMPCONTAINERID:/usr/sbin/my_init                                        changerelevant-${VER}/usr/sbin/my_init
  docker cp $TMPCONTAINERID:/etc/container_environment.json                          changerelevant-${VER}/etc/container_environment.json
  docker cp $TMPCONTAINERID:/etc/container_environment.sh                            changerelevant-${VER}/etc/container_environment.sh
  docker cp $TMPCONTAINERID:/etc/container_environment                               changerelevant-${VER}/etc
  docker cp $TMPCONTAINERID:/etc/my_init.d                                           changerelevant-${VER}/etc
  docker cp $TMPCONTAINERID:/etc/my_init.post_shutdown.d                             changerelevant-${VER}/etc
  docker cp $TMPCONTAINERID:/etc/my_init.pre_shutdown.d                              changerelevant-${VER}/etc
  docker rm -v $TMPCONTAINERID
done
echook

echoc ${BLUE} "Creating hist-repo..."
rm -rf changerelevant-hist
git init changerelevant-hist
cd changerelevant-hist/
for VER in ${VERSIONS[*]}
do
  rm -rf scripts
#  rm -rf opt
  rm -rf usr
  rm -rf etc
  cp -r ../changerelevant-${VER}/* .
  git add .
  git commit -a --allow-empty -m "${VER}"
done
cd ..
echook
