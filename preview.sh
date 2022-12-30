#!/usr/bin/env bash

export WEBDIR=$(dirname $(realpath "$0"))
cd $WEBDIR
set -ex

# rsync -av node_modules/utax/*.js lib/utax &
#./build.product.sh
# bun run pug -- index.pug -o lib

kill -9 $(lsof -t -i:8888) || true
./sh/open.sh &

# bun dev 会导致css单引号变成双引号，然后svg无法显示
exec openresty -c $WEBDIR/iuser.openresty.conf
