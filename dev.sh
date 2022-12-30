#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
set -ex

#./sh/build.config.sh
./demo.sh

cd $DIR
bun run concurrently -- \
  --kill-others \
  "direnv exec ../skin/dev.sh" \
  "bun run stylus -- -w -o lib/demo demo/*.styl" \
  "bun run pug -- -w -o lib/demo demo/index.pug" \
  "./preview.sh" \
  "./dev.svelte.sh"
