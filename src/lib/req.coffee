#!/usr/bin/env coffee

# 防止重复请求
< req = (...args)=>
  n = 0
  loop
    try
      r = await fetch(...args)
      if r.ok or [404,304].includes(r.status)
        break
      else
        throw r
    catch err
      if err.name == 'AbortError'
        return
      if ++n < 7
        continue
      else
        throw err
  if r.headers.get('content-type').endsWith('/json')
    return r.json()
  else
    return new Uint8Array await r.arrayBuffer()

< Req = =>
  + ctrl
  (next, url, opt)=>
    opt = opt or {}

    if ctrl
      ctrl.abort()
    ctrl = new AbortController()
    opt.signal = ctrl.signal
    r = await req(url,opt)
    ctrl = undefined
    return next r
