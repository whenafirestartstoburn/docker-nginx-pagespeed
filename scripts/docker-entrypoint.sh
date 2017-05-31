#!/bin/bash

docker-fetchsites.sh || exit 1

set -e

if [[ "$1" == -* ]]; then
    set -- nginx -g daemon off; "$@"
fi

exec "$@"
