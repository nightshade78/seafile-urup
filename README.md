# About
Seafile Server UnRooted UnProxxed - A docker image for Seafile server with the following modifications:
 - optimized for usage with a non-root web path
 - does not contain internal nginx revproxy (has to be provided by a second container, other machine, whatever)
 - does not allow for https or letsencrypt
 - serves the static content itself
 - based directly upon the official ubuntu image
 - (optionally) allows the container to run under a dedicated user account (instead of the default root one)

# Contents
This project contains the following:
 - image: Everything that is needed for building the baseimage as well as a (optional, required for running a dedicated user account) custom image
 - sample: Sample seafile config and scripts for starting the containers (with placeholders, needs to be adapted for your personal use first!)
 - utils-helpers: Some helper utilities, mainly for relevant extracting changes from the original seafile-mc image versions

# Requirements
Intention was to use the bare minimum of required commands for building this (without make or anything of the like):
 - bash
 - wget
 - tar
 - sed
 - docker

# Thanks, credits, etc.
First of all, the whole team of Seafile for their great work - both on the software itself and on the original seafile-mc Docker image (from which this one here is derived).
Both great portions of the baseimage Dockerfile as well as the scripts portion are the original work of the Seafile team available from https://github.com/haiwen/seafile-docker. My original intention was to get the code on-the-fly during build and to modify it accordingly with sed, but that would have turned out to be a load of very unreadable sed commands. So I tried to keep the original files as far as possible and wherever required, the original code is kept in comments (for easier keeping track of updates on the original repo).

Second, the whole team of Phusion for their great work on the docker container optimizations for the original Ubuntu.
Both some portions of the baseimage Dockerfile as well as the bd_build portion are the original work of the Phusion team available from https://github.com/phusion/baseimage-docker. Yet again, I tried to keep the original files as far as possible and wherever required, the original code is kept in comments (for easier keeping track of updates on the original repo).
Despite all the good work, the Phusion image versioning and tagging is not very clear and stringent (plus I don't need the sshd and cron services in this image here), so that is why I decided to apply only the required Phusion modifications onto the original Ubuntu image directly.

Third, the whole team of Ubuntu for their great work.
