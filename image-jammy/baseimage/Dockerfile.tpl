# Build baseimage from ubuntu image
FROM ubuntu:UBTVERARG

# Set maintainer
MAINTAINER nightshade@tdfc.de

# Apply the changes usually done by Phusion (except sshd and cron), see https://github.com/phusion/baseimage-docker
COPY files/bd_build /bd_build
RUN /bd_build/prepare.sh && \
    /bd_build/system_services.sh && \
    /bd_build/utilities.sh && \
    /bd_build/cleanup.sh
ENV DEBIAN_FRONTEND="teletype" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"

# Variables
ENV SEAFILE_SERVER=seafile-server
ENV SEAFILE_VERSION=SFLVERARG
ENV IMAGE_DESCRIPTION="SeaFile Server UnRooted UnProxxed - A container which serves a SeaFile server modified for usage with a non-root web path and an external proxy"

# Update apt repo data
RUN apt-get update --fix-missing

# Utility tools
RUN apt-get install -y vim htop net-tools psmisc wget curl git nano

# For support set local time zone.
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install tzdata -y

# Mysqlclient
RUN apt-get install -y libmysqlclient-dev

# Memcache
RUN apt-get install -y libmemcached11 libmemcached-dev

# libffi
RUN apt-get install -y libffi-dev

# Fuse
RUN apt-get install -y fuse

# Ldap
RUN apt-get install -y ldap-utils ca-certificates && \
    mkdir -p /etc/ldap && \
    echo "TLS_REQCERT     allow" >> /etc/ldap/ldap.conf

# Python3
RUN apt-get install -y python3 python3-pip python3-setuptools
RUN rm -f /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python
RUN python3 -m pip install --upgrade pip && rm -r /root/.cache/pip
RUN pip3 install --timeout=3600 click termcolor colorlog pymysql \
    django==3.2.* lxml && rm -r /root/.cache/pip
RUN pip3 install --timeout=3600 future mysqlclient Pillow pylibmc captcha markupsafe==2.0.1 jinja2 \
    sqlalchemy==1.4.3 django-pylibmc django-simple-captcha pyjwt pycryptodome==3.12.0 && \
    rm -r /root/.cache/pip

# Cleanup apt caches
RUN rm -r /var/lib/apt/lists/*

# Scripts
COPY files/scripts /scripts
RUN chmod ugoa+x /scripts/* && \
    rm /scripts/cluster* && \
    mkdir -p /etc/my_init.d && \
    rm -f /etc/my_init.d/* && \
    cp /scripts/create_data_links.sh /etc/my_init.d/01_create_data_links.sh

# Seafile
WORKDIR /opt/seafile/seafile-server-SFLVERARG
ADD generated/seafile-server-SFLVERARG .
WORKDIR /opt/seafile

# cffi into Seafile thirdpart
RUN pip3 install --force-reinstall --upgrade --target /opt/seafile/seafile-server-SFLVERARG/seahub/thirdpart cffi==1.14.6

# Expose ports
EXPOSE 8082
EXPOSE 8000

# Entry point command
CMD [ "/sbin/my_init", "--", "/scripts/enterpoint.sh" ]
