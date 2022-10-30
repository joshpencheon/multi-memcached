FROM memcached:1.6-alpine

LABEL org.opencontainers.image.source=https://github.com/joshpencheon/multi-memcached
LABEL org.opencontainers.image.description="Run multiple memcached instances in a single container"

USER root
RUN apk add bash
USER memcache

ARG total_instances=5
ENV TOTAL_INSTANCES=$total_instances

COPY docker-entrypoint.sh /usr/local/bin/
