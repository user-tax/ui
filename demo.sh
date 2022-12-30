#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
set -ex

#./sh/build.config.sh

LIB=$DIR/lib
OUT=$LIB/demo
mkdir -p $OUT
cd $OUT

RP=../../demo
ln -s $RP/*.svg $OUT || true
ln -s $RP/*.ico $OUT >/dev/null 2>&1 || true
ln -s $RP/*.js $OUT || true

if [ ! -s "i18n" ]; then
  ln -s ../../demo/i18n/json i18n || true
fi

cd $DIR/demo

bun run stylus -- -o ../lib/demo *.styl
bun run pug -- -o ../lib/demo index.pug
