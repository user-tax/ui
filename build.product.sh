#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex
export NODE_ENV=production
rm -rf lib

./build.sh
./sh/css_reuse.coffee
./sh/minify.svelte.coffee
#esbuild --allow-overwrite --minify --charset=utf8 --target=chrome107,safari16,firefox105,edge103 --outdir=lib lib/*.js
./sh/minify.coffee.coffee
../skin/build.coffee
./sh/compressed.size.coffee
mdi
