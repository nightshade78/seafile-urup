# -*- coding: utf-8 -*-
# paste created value from original installation
SECRET_KEY = "WhatEver...=="

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
# paste settings from original installation
        'NAME': 'seahub-db',
        'USER': 'seafile',
        'PASSWORD': 'seafile-dbuser-password',
        'HOST': 'mariadb',
        'PORT': '3306',
        'OPTIONS': {'charset': 'utf8mb4'}
    }
}

CACHES = {
    'default': {
        'BACKEND': 'django_pylibmc.memcached.PyLibMCCache',
        'LOCATION': 'memcached:11211',
    },
    'locmem': {
        'BACKEND': 'django.core.cache.backends.locmem.LocMemCache',
    },
}
COMPRESS_CACHE_BACKEND = 'locmem'

## Needed as the proxy will be on a different machine
## and cannot serve the static content itself
SERVE_STATIC = True
## Needs to be set for serving static content under a subfolder
MEDIA_URL = '/seafile/media/'
COMPRESS_URL = MEDIA_URL
STATIC_URL = MEDIA_URL + 'assets/'
## Needs to be set for serving under subfolder
SITE_ROOT = '/seafile/'
LOGIN_URL = '/seafile/accounts/login/'
LOGOUT_URL = '/seafile/accounts/logout/'
## Needs to be set for access to seafile via proxy
FILE_SERVER_ROOT = 'https://host.domain.tld/seafhttp'
EMAIL_USE_TLS = False
EMAIL_HOST = '1.2.3.4'                  # smtp server
EMAIL_HOST_USER = 'seafile@domain.tld'  # username and domain
EMAIL_HOST_PASSWORD = ''                # password
EMAIL_PORT = 25
DEFAULT_FROM_EMAIL = EMAIL_HOST_USER
SERVER_EMAIL = EMAIL_HOST_USER
TIME_ZONE = 'Europe/Berlin'
LANGUAGE_CODE = 'de-DE'
SITE_NAME = 'Seafile'
SITE_TITLE = 'My-Seafile'

SERVICE_URL = 'https://host.domain.tld/seafile'
## Important: Do NOT use a trailing / after the TLD!
CSRF_TRUSTED_ORIGINS = ["https://host.domain.tld"]

#OFFICE_CONVERTOR_ROOT = 'http://office-preview:8089'
