FROM docker.io/tiredofit/nginx-php-fpm:8.1
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

### Set Environment Variables
ENV TEAMPASS_VERSION=3.0.0.21 \
    TEAMPASS_REPO_URL=https://github.com/nilsteampassnet/TeamPass \
    PHP_ENABLE_CREATE_SAMPLE_PHP=FALSE \
    PHP_ENABLE_LDAP=TRUE \
    PHP_ENABLE_MYSQLI=TRUE \
    PHP_FPM_OUTPUT_BUFFER_SIZE=4096 \
    NGINX_WEBROOT=/www/teampass \
    IMAGE_NAME="tiredofit/teampass" \
    IMAGE_REPO_URL="https://github.com/tiredofit/docker-teampass/"

### Dependencies Installation
RUN set -x && \
    apk update && \
    apk upgrade && \
    apk add -t .teampass-build-deps \
               git \
               && \
    apk add -t .teampass-run-deps \
               gnu-libiconv \
               && \
    \
    php-ext enable core && \
    mkdir -p /assets/install && \
    git clone ${TEAMPASS_REPO_URL} /assets/install && \
    cd /assets/install && \
    git checkout ${TEAMPASS_VERSION} && \
    chown -R ${NGINX_USER}:${NGINX_GROUP} /assets/install && \
    chmod -R +w /assets/install/install && \
    rm -rf /assets/install/*.md /assets/install/*.sh /assets/install/*.yml /assets/install/Dockerfile && \
    apk del .teampass-build-deps && \
    rm -rf /var/tmp/* /var/cache/apk/*

ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

### Files Addition
ADD install /
