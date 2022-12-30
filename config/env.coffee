import {join} from 'path'
import thisdir from '@rmw/thisdir'

{
  IUSER_CDN:CDN
  IUSER_PREFIX:PREFIX
  NODE_ENV
} = process.env


export CDN = CDN or '//user0.ga/'
export DEV = NODE_ENV != 'production'
export ROOT = thisdir import.meta
export SRC = join ROOT,'src'
