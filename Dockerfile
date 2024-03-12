# syntax=docker/dockerfile:1
#
ARG IMAGEBASE=frommakefile
#
FROM ${IMAGEBASE}
#
ENV \
    NODE_OPTIONS="--max-old-space-size=3072"
#
RUN set -xe \
    # && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk add -Uu --purge --no-cache \
        curl \
        git \
        openssl \
        # nodejs \
        # npm \
        # yarn \
# 20240312 arm32 v6/v7 npm install still keeps hanging.
# sticking to previous 18.x.x from 3.18 repos for now, until
# https://github.com/nodejs/docker-node/issues/1946 is resolved
    && { \
        echo "http://dl-cdn.alpinelinux.org/alpine/v3.18/main"; \
        echo "http://dl-cdn.alpinelinux.org/alpine/v3.18/community"; \
    } > /tmp/repo3.18 \
    && apk add --no-cache \
        --repositories-file "/tmp/repo3.18" \
        nodejs \
        npm \
        yarn \
    && if [ -n $(which npm) ]; then \
        echo "Updating npm and yarn to latest"; \
        npm install -g \
            npm@latest \
            yarn@latest \
        ; \
    fi \
    && npm ls \
    && find /usr/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf \
    && rm -rf \
        /root/.node-gyp \
        /root/.npm \
        /tmp/* \
        /usr/lib/node_modules/npm/doc \
        /usr/lib/node_modules/npm/html \
        /usr/lib/node_modules/npm/man \
        /usr/share/man \
        /var/cache/apk/*
#
COPY root/ /
#
ENTRYPOINT ["/usershell"]
#
CMD ["node", "--version"]
