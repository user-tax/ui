#!/usr/bin/env coffee

import {createWriteStream} from 'fs'
import thisdir from '@rmw/thisdir'
import {dirname,join} from 'path'
import {walkRel} from '@iuser/walk'
import intoStream from 'into-stream'
import { pipeline } from 'stream/promises'
> @iuser/read

DIR = thisdir(import.meta)
ROOT = dirname DIR
SRC = join ROOT,'src'

await pipeline(
  intoStream do ->
    for await i from walkRel(
      SRC
      (i)=>
        i=='styl'
    )
      if i.endsWith('.svelte')
        yield "import './#{i}';\n"
    yield await read join(SRC,'mod.js')
  createWriteStream join SRC,'index.js'
)

