#!/usr/bin/env coffee

> ./env > LIB
  @u7/walk
  @u7/read
  @u7/write
  path > join

for await fp from walk LIB
  rel = =>
    dir = fp[LIB.length+1..]
    (
      '../'.repeat(
        dir.split('/').length-1
      ) or './'
    )

  if fp.endsWith '.js'
    change = 0

    js = read(fp).replace(
      / from ('|")\!\//g
      (line, q)=>
        change = 1
        ' from '+q+rel()
    ).replace(
      /^import ('|")\!\//g
      (line, q)=>
        change = 1
        'import '+q+rel()
    ).replace(
      / from ('|")utax\//g
      (line, q)=>
        change = 1
        ' from '+q+rel()+'utax/'
    )
    .replace(
      /import ('|")utax\//g
      (line, q)=>
        change = 1
        'import '+q+rel()+'utax/'
    )

    if change
      write fp, js
