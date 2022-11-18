#!/bin/bash
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- memcached "$@"
fi

# Drop any port flags, prefer environment variables:
OTHER_ARGS=()
while [[ $# -gt 0 ]]; do
    case $1 in
        -p|--port|-U|--udp-port)
            shift 2
            ;;
        *)
            OTHER_ARGS+=("$1")
            shift
            ;;
    esac
done
set -- "${OTHER_ARGS[@]}"

# Start instances in the background:
for i in $(seq 1 "$TOTAL_INSTANCES"); do
    CMD="$*"
    if [ "$STARTING_TCP_PORT" -gt 0 ]; then
        (( tcp_port = STARTING_TCP_PORT + i - 1 ))
        CMD+=" -p $tcp_port"
    else
        CMD+=" -p 0"
    fi
    if [ "$STARTING_UDP_PORT" -gt 0 ]; then
        (( udp_port = STARTING_UDP_PORT + i - 1 ))
        CMD+=" -U $udp_port"
    fi
    eval "$CMD &"
done

# Wait for any instances to exit:
wait -n
