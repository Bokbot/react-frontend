#!/bin/bash
set -e

echo 'start bokbot react frontend'

if [ -z ${CAM_HOST+x} ]
then
  echo "CAM_HOST is unset"
  exit
fi

if [ -z ${CAM_PORT+x} ]
then
  echo "CAM_PORT is unset"
  exit
fi

echo 'Generate config.js'
cd /usr/share/nginx/html/assets
envsubst < config.js.template \
> /usr/share/nginx/html/src/config.js

echo 'Start NGINX'
nginx -g "daemon off;"
