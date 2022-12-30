#!/usr/bin/env coffee

> esbuild > build
  @rmw/thisdir
  path > join dirname

ROOT = join(
  dirname thisdir import.meta
  'lib'
)

bundle = ([js,external])=>
  fp = join ROOT, js
  dir = dirname fp
  js = fp[dir.length+1..]
  console.log dir, js
  build({
    external
    absWorkingDir: dir
    bundle: true
    logLevel: "info"
    entryPoints: [
      js
    ]
    outdir: dir
    allowOverwrite: true
    #minify: true
    format: "esm"
  }).catch =>
    process.exit(1)


await Promise.all [
  [
    "lib/SDK.js"
    [
      './captcha.js'
    ]
  ]
].map bundle

