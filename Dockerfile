# syntax=docker/dockerfile:1
#
ARG IMAGEBASE=frommakefile
#
FROM ${IMAGEBASE}
#
RUN set -xe \
    # && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk add -Uu --purge --no-cache \
        curl \
        git \
        openssl \
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
