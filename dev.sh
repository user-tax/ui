#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
set -ex

#./sh/build.config.sh

rm -rf lib

./demo.sh

cd $DIR
bun run concurrently -- \
  -r --kill-others \
  "direnv exec ../styl/dev.sh" \
  "bun run stylus -- -w -o lib/demo demo/file/*.styl" \
  "bun run pug -- -w -o lib/demo demo/file/index.pug" \
  "./preview.sh" \
  "./dev.svelte.sh"
