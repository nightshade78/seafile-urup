# See https://hub.docker.com/r/phusion/baseimage/tags/
# TODO: Build baseimage from ubuntu image, with mods (except sshd and cron) done by https://github.com/phusion/baseimage-docker
FROM phusion/baseimage:PHNVERARG

# Set maintainer
MAINTAINER nightshade@tdfc.de

# Variables
ENV SEAFILE_SERVER=seafile-server
ENV SEAFILE_VERSION=SFLVERARG
ENV IMAGE_DESCRIPTION="SFLDESCARG"
#ENV TZ=Europe/Berlin

# Use german timezone
# TODO?: TimeZone via run env var?
#RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Run updates (phusion might not always be as up-to-date as Ubuntu itself)
RUN apt-get update --fix-missing && \
    apt-get -y upgrade && \
    apt-get -y dist-upgrade

# Utility tools
RUN apt-get install -y vim htop net-tools psmisc wget curl git nano

# For support set local time zone.
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install tzdata -y

# Mysqlclient
RUN apt-get install -y libmysqlclient-dev

# Memcache
RUN apt-get install -y libmemcached11 libmemcached-dev

# Fuse
RUN apt-get install -y fuse

# Ldap
RUN apt-get install -y ldap-utils ca-certificates && \
    echo "TLS_REQCERT     allow" >> /etc/ldap/ldap.conf

# Python3
RUN apt-get install -y python3 python3-pip python3-setuptools
RUN rm -f /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python
RUN python3 -m pip install --upgrade pip && rm -r /root/.cache/pip
RUN pip3 install --timeout=3600 click termcolor colorlog pymysql \
    django==3.2.* && rm -r /root/.cache/pip
RUN pip3 install --timeout=3600 future mysqlclient Pillow pylibmc captcha jinja2 \
    sqlalchemy==1.4.3 django-pylibmc django-simple-captcha pyjwt pycryptodome==3.12.0 cffi==1.14.0 && \
    rm -r /root/.cache/pip

# Remove SSH and CRON daemons from parent image
RUN rm -r /var/run/sshd && \
    rm -r /etc/service/sshd && \
    rm -r /root/.ssh && \
    rm /etc/insecure_key.pub && \
    rm /etc/insecure_key && \
    rm /usr/sbin/enable_insecure_key && \
	rm -r /etc/service/cron && \
    apt-get -y remove openssh-server cron && \
	apt-get -y autoremove

# Cleanup apt caches
RUN rm -r /var/lib/apt/lists/*

# Scripts
COPY files/scripts /scripts
RUN chmod ugoa+x /scripts/* && \
    rm /scripts/cluster* && \
    mkdir -p /etc/my_init.d && \
    rm -f /etc/my_init.d/* && \
    cp /scripts/create_data_links.sh /etc/my_init.d/01_create_data_links.sh

# Permission fixes for running container in user context
RUN chmod -R ugoa+rwx /etc/container_environment && \
    chmod ugoa+rwx /etc/container_environment.sh && \
    chmod ugoa+rw /etc/container_environment.json && \
    chmod ugoa+rw /etc && \
    chmod ugoa+rw /etc/localtime && \
    chmod ugoa+rw /etc/timezone && \
    mkdir -p /shared && \
    chmod ugoa+rwx /shared && \
    mkdir -p /opt/seafile && \
    chmod ugoa+rwx /opt/seafile && \
    chmod -R ugoa+rw /var/log && \
    chmod ugoa+rw /var && \
    mkdir -p /bootstrap && \
    chmod ugoa+rwx /bootstrap

# Seafile
WORKDIR /opt/seafile/seafile-server-SFLVERARG
ADD generated/seafile-server-SFLVERARG .
WORKDIR /opt/seafile

# For using TLS connection to LDAP/AD server with docker-ce.
RUN find /opt/seafile/ \( -name "liblber-*" -o -name "libldap-*" -o -name "libldap_r*" -o -name "libsasl2.so*" -o -name "libcrypt.so.1" \) -delete

# Expose ports
EXPOSE 8082
EXPOSE 8000

# Entry point command
CMD [ "/sbin/my_init", "--", "/scripts/enterpoint.sh" ]
