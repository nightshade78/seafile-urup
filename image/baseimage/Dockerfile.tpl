# Build baseimage from ubuntu image
FROM ubuntu:UBTVERARG

# Set maintainer
LABEL maintainer="Nightshade nightshade@tdfc.de"

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
    # apt-get upgrade NOT required here, this is already done earlier during /bd_build/prepare.sh
    # Utility tools
    && apt-get install -y vim htop net-tools psmisc wget curl git unzip nano \
    # For support set local time zone.
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install tzdata -y \
    # Mysqlclient
    && apt-get install -y libmysqlclient-dev \
    # Memcache
    && apt-get install -y libmemcached11 libmemcached-dev \
    # Fuse
    && apt-get install -y fuse \
    # Ldap
    && apt-get install -y ldap-utils libldap2-dev ca-certificates \
    && mkdir -p /etc/ldap \
    && echo "TLS_REQCERT     allow" >> /etc/ldap/ldap.conf \
    # Python3
    && apt-get install -y python3 python3-dev python3-pip python3-setuptools python3-ldap \
    && rm -f /usr/bin/python \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && python3 -m pip install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir --timeout=3600 click termcolor colorlog pymysql django==4.2.* future==0.18.* mysqlclient==2.1.* pillow==10.2.* pylibmc captcha==0.5.* markupsafe==2.0.1 jinja2 sqlalchemy==2.0.18 django-pylibmc django_simple_captcha==0.6.* pyjwt==2.6.* djangosaml2==1.5.* pysaml2==7.2.* pycryptodome==3.16.* cffi==1.15.1 python-ldap==3.4.3 psd-tools lxml \
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
WORKDIR /opt/seafile
COPY generated/seafile-server-SFLVERARG /opt/seafile/seafile-server-SFLVERARG

# Expose ports
EXPOSE 8082
EXPOSE 8000
EXPOSE 8083

# Entry point command
CMD [ "/sbin/my_init", "--", "/scripts/enterpoint.sh" ]
