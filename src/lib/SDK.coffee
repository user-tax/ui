> @user.tax/sdk
  ./captcha.js

[proxy, sdkConf] = sdk(
  (r, call, url, o)=>
    if r instanceof Error
      alert '❌ '+r.message
      throw r
    {status} = r
    if status == 412
      c = await captcha()
      if Number.isNaN c
        return c
      else
        o.headers['Content-Type'] = c
        call url, o
    else
      throw r
)

< sdkConf = sdkConf
< default proxy

# window.SDK = proxy
