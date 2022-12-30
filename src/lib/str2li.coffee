#!/usr/bin/env coffee

export default (li)->
  r  = []
  iter = li[Symbol.iterator]()
  for i from iter
    r.push [i,iter.next().value]
  r


