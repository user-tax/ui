#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

try_wait() {
  wait || {
    echo "error : $?" >&2
    exit 1
  }
}

rsync -av --include="*/" \
  --include="*.js" \
  --exclude="*" \
  ./node_modules/utax/* lib/utax/ &

bun run cep -- -c svelteup.config.coffee >/dev/null &
bun run cep -- -o lib -c src >/dev/null

mkdir -p lib/gen
cat $DIR/src/gen/I18N_VER.js >lib/gen/I18N_VER.js
cat $DIR/src/gen/i18n.js >lib/gen/i18n.js

bun run cep -- -c ./config >/dev/null &
direnv exec ./sh/index.js.gen.coffee &
rsync -av ../skin/lib/ lib &

try_wait

bun run svelteup
direnv exec ./sh/svelte_module.coffee &
rm -rf *.bundled_*.mjs
direnv exec ./sh/esbuild.coffee &

try_wait
