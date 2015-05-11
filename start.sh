#!/bin/bash

if [ -d "/var/www/html" ]; then
    chown -R nginx:nginx /var/www/html
fi

exec "$@"