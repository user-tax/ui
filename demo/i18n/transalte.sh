#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

if [ ! -d 'node_modules' ]; then
  bun i
fi
bun run i18n -- en -d .
