#!/usr/bin/env coffee

import thisdir from '@rmw/thisdir'
import {dirname,join} from 'path'

export DIR = thisdir(import.meta)
export ROOT = dirname DIR
export SRC = join ROOT,'src'
export LIB = join ROOT,'lib'
export LIB_INDEX = join LIB,'index.js'
