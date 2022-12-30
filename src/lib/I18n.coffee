> ./req.js > Req

decode = new TextDecoder()

< NULL = new Proxy(
  {}
  get:=>
    '　'
)

NOW = NULL

< getI18N = =>
  NOW

< =>
  req = Req()
  hook = new Set

  set = (i18n)->
    NOW = i18n
    # 如果不走网络请求json，可以直接调用这个接口传入i18n的字典
    for i from hook
      i(i18n)
    return

  [

    # onMount
    (func)=>
      func(NOW)
      =>
        hook.add func
        =>
          hook.delete(func)
          return

    # get
    (url)=>
      req(
        (r)=>
          li = []
          p = 0
          loop
            n = r.indexOf(0, p)
            if ~ n
              li.push r[p..n-1]
              p = n+1
            else
              li.push r[p..]
              break
          set li.map (i)=>decode.decode(i)
          return
        url
      )

    set
  ]
