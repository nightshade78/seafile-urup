# Build customuser image from baseimage image
FROM nightshade78/seafile-urup-baseimage:BASEVERARG

# Create image-internal user/group seafile:seafile if according IDs are not 0
# Also apply permission fixes for running container in user context
RUN if [ TGTUIDARG -ne 0 ] && [ TGTGIDARG -ne 0 ]; then \
      groupadd -g TGTGIDARG seafile && \
      useradd -l -u TGTUIDARG -g seafile seafile && \
      install -d -m 0755 -o seafile -g seafile /home/seafile && \
      chmod -R ugoa+rwx /etc/container_environment && \
      chmod ugoa+rwx /etc/container_environment.sh && \
      chmod ugoa+rw /etc/container_environment.json && \
      chmod ugoa+rw /etc && \
      chmod ugoa+rw /etc/localtime && \
      chmod ugoa+rw /etc/timezone && \
      mkdir -p /shared && \
      chown -R seafile:seafile /shared && \
      chmod -R ugoa+rw /var/log && \
      chmod ugoa+rw /var && \
      mkdir -p /bootstrap && \
      chmod ugoa+rwx /bootstrap && \
      chown -R seafile:seafile /opt/seafile \
    ;fi
