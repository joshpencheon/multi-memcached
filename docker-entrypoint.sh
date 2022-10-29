#!/bin/bash
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- memcached "$@"
fi

# extract out any supplied ports:
OTHER_ARGS=()
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--port)
            STARTING_TCP_PORT="$2"
            shift 2
            ;;
        -U|--udp-port)
            STARTING_UDP_PORT="$2"
            shift 2
            ;;
        *)
            OTHER_ARGS+=("$1")
            shift
            ;;
    esac
done
set -- "${OTHER_ARGS[@]}"

# Set default port config:
STARTING_TCP_PORT="${STARTING_TCP_PORT:-11211}"
STARTING_UDP_PORT="${STARTING_UDP_PORT:-0}"

# Start instances in the background:
for i in `seq 1 $TOTAL_INSTANCES`; do
    CMD="$@"
    if [ $STARTING_TCP_PORT -gt 0 ]; then
        let tcp_port=$STARTING_TCP_PORT+$i-1
        CMD+=" -p $tcp_port"
    else
        CMD+=" -p 0"
    fi
    if [ $STARTING_UDP_PORT -gt 0 ]; then
        let udp_port=$STARTING_UDP_PORT+$i-1
        CMD+=" -U $udp_port"
    fi
    eval "$CMD &"
done

# Wait for any instances to exit:
wait -n
