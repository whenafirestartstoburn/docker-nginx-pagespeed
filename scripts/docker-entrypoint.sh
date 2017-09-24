#!/bin/bash

echo "starting nginx web server..."

/usr/local/bin/initialize.sh || exit 1

set -e

if [[ "$1" == -* ]]; then
    set -- nginx -g daemon off; "$@"
fi

exec "$@"
