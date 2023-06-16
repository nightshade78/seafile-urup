# Build baseimage from ubuntu image
FROM ubuntu:UBTVERARG

# Set maintainer
MAINTAINER nightshade@tdfc.de

# Apply the changes usually done by Phusion (except sshd and cron), see https://github.com/phusion/baseimage-docker
COPY files/bd_build /bd_build
RUN /bd_build/prepare.sh \
    && /bd_build/system_services.sh \
    && /bd_build/utilities.sh \
    && /bd_build/cleanup.sh
ENV DEBIAN_FRONTEND="teletype" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8" \
    # Variables
    SEAFILE_SERVER=seafile-server \
    SEAFILE_VERSION=SFLVERARG \
    IMAGE_DESCRIPTION="SeaFile Server UnRooted UnProxxed - A container which serves a SeaFile server modified for usage with a non-root web path and an external proxy"

    # Update apt repo data
RUN apt-get update --fix-missing \
    # Utility tools
    && apt-get install -y vim htop net-tools psmisc wget curl git nano \
    # For support set local time zone.
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install tzdata -y \
    # Mysqlclient
    && apt-get install -y libmysqlclient-dev \
    # Memcache
    && apt-get install -y libmemcached11 libmemcached-dev \
    # libffi
    && apt-get install -y libffi-dev \
    # Fuse
    && apt-get install -y fuse \
    # Ldap
    && apt-get install -y ldap-utils ca-certificates \
    && mkdir -p /etc/ldap \
    && echo "TLS_REQCERT     allow" >> /etc/ldap/ldap.conf \
    # Python3
    && apt-get install -y python3 python3-pip python3-setuptools \
    && rm -f /usr/bin/python \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && python3 -m pip install --upgrade pip \
    && rm -r /root/.cache/pip \
    && pip3 install --timeout=3600 click termcolor colorlog pymysql django==3.2.* future==0.18.* mysqlclient==2.1.* pillow==9.3.* pylibmc captcha==0.4 markupsafe==2.0.1 jinja2 sqlalchemy==1.4.3 django-pylibmc django_simple_captcha==0.5.* pyjwt==2.6.* djangosaml2==1.5.* pysaml2==7.2.* pycryptodome==3.16.* cffi==1.15.1 psd-tools lxml \
    && rm -r /root/.cache/pip \
    # Cleanup apt caches
    && rm -r /var/lib/apt/lists/*

# Scripts
COPY files/scripts /scripts
RUN chmod ugoa+x /scripts/* \
    && rm /scripts/cluster* \
    && mkdir -p /etc/my_init.d \
    && rm -f /etc/my_init.d/* \
    && cp /scripts/create_data_links.sh /etc/my_init.d/01_create_data_links.sh

# Seafile
WORKDIR /opt/seafile/seafile-server-SFLVERARG
ADD generated/seafile-server-SFLVERARG .
WORKDIR /opt/seafile

# Expose ports
EXPOSE 8082
EXPOSE 8000
EXPOSE 8083

# Entry point command
CMD [ "/sbin/my_init", "--", "/scripts/enterpoint.sh" ]