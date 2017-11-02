#!/bin/bash

set -e

WAIT_FOR=${WAIT_FOR}
WAIT_RETRIES=${WAIT_RETRIES:-30}
WAIT_DELAY=${WAIT_DELAY:-2}

if [ -n "$WAIT_FOR" ]; then
    WAIT_DEV=${WAIT_FOR//://}
    for retry in $(seq ${WAIT_RETRIES}); do
        echo "(${retry}/${WAIT_RETRIES}) Try to connect to ${WAIT_FOR}"
        echo > /dev/tcp/${WAIT_DEV} 2> /dev/null && break
        sleep $WAIT_DELAY
    done
    echo > /dev/tcp/${WAIT_DEV}
    echo "Connected to ${WAIT_FOR}"
fi
