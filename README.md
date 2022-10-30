# Multi-memcached

A docker container that runs a configurable number of memcached instances.

## Configuration

By default, the container will start 5 instances on TCP `:11211-11215`:

```
docker run -it \
  -p 11211-11215:11211-11215 \
  ghcr.io/joshpencheon/multi-memcached:latest
```

You can start more instances with an environment variable:

```
docker run -it \
  -e TOTAL_INSTANCES=10 \
  -p 11211-11220:11211-11220 \
  ghcr.io/joshpencheon/multi-memcached:latest
```

You can change the starting port:

```
docker run -it \
  -p 12345-12349:12345-12349 \
  ghcr.io/joshpencheon/multi-memcached:latest \
  --port 12345
```

Or access via UDP rather than TCP:

```
docker run -it \
  -p 12345-12349:12345-12349/udp \
  ghcr.io/joshpencheon/multi-memcached:latest \
  --U 12345 --port 0
```

## Building

The default number of instances is 5, but this can be changed at build time too:

```
docker build --build-arg instances=20 .
```
