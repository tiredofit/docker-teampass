FROM docker.io/tiredofit/nginx-php-fpm:7.3
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

### Set Environment Variables
ENV TEAMPASS_VERSION=2.1.27.36 \
    PHP_ENABLE_CREATE_SAMPLE_PHP=FALSE \
    PHP_ENABLE_LDAP=TRUE \
    PHP_ENABLE_MYSQLI=TRUE \
    NGINX_WEBROOT=/www/teampass

### Dependencies Installation
RUN set -x && \
    apk update && \
    apk upgrade && \
    apk add -t .teampass-run-deps \
               gnu-libiconv \
               && \
    \
    rm -rf /var/cache/apk/*

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

### Files Addition
ADD install /
