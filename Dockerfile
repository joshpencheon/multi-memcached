FROM memcached:1.6-alpine

USER root
RUN apk add bash
USER memcache

ARG total_instances=5
ENV TOTAL_INSTANCES=$total_instances

COPY docker-entrypoint.sh /usr/local/bin/
