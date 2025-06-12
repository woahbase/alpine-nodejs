# syntax=docker/dockerfile:1
#
ARG IMAGEBASE=frommakefile
#
FROM ${IMAGEBASE}
#
RUN set -xe \
    && apk add -Uu --purge --no-cache \
        curl \
        git \
        openssl \
# use current available packages
        nodejs \
        npm \
        pnpm \
        yarn \
#
    && if [ -n $(which npm) ]; then \
        echo "Updating npm and yarn to latest"; \
        npm install -g \
            --fetch-retries=5 \
            --no-audit \
            --no-fund \
            --no-update-notifier \
            npm@latest \
            pnpm@latest \
            yarn@latest \
            # corepack@latest \
        ; \
    fi \
# # let corepack handle pnpm/yarn installation
#     && corepack enable pnpm yarn \
#     # && corepack pack pnpm@latest \
#     # && corepack install -g pnpm@latest \
#     # && pnpm --version \
#     # && corepack pack yarn@latest \
#     # && corepack install -g yarn@latest \
#     # && yarn --version \
    && npm ls \
    && find /usr/lib/node_modules/npm -name test -o -name .bin -type d | xargs rm -rf \
    && rm -rf \
        /root/.cache \
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
