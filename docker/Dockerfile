FROM node:24-alpine

RUN apk add --no-cache git coreutils

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]