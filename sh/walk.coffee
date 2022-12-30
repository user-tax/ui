#!/usr/bin/env coffee

import 'zx/globals'
import thisdir from '@rmw/thisdir'

ROOT = thisdir(import.meta)
cd ROOT

export default main = =>
  await $'ls'
  await $'pwd'

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  await main()
  process.exit()

