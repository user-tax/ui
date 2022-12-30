#!/usr/bin/env coffee

> ../../gen/i18n.js > MAIL CREATE_ACCOUNT NAME RESET_PASSWORD USED
  ./captcha.js
  ../../lib/SDK.js
  ../../utax/On.js
  ../../lib/byTag.js
  ../../setDone.js
  ../../Box.js > tagBox
  ../../User.js > userSet
  ../../utax/assign.js
  ../../utax/wcut.js
  ../../index.js > uSetMail

uSetMail()

{mail} = SDK.auth
{signup,resetPassword,set} = mail

mail = captcha mail
setMail = captcha set.mail

_box = (account, password, send, option)=>
  [box,b] = tagBox 'u-auth-mail-code'

  assign b,{
    account
    send
  }
  assign b, option
  return box

_user = (r, account)=>
  userSet r, MAIL, account

_signup = (account,password,send)=>
  box = _box(
    account,password,send
    btn: CREATE_ACCOUNT
    slot: (I18N)=>
      """<u><input maxlength="28" placeholder=" " type="text" id="uName" autocomplete="off" required><label for="uName">#{I18N[NAME]}</label></u>"""
    next:(code) ->
      input = byTag(@,'input')[1]
      input.value = name = wcut input.value.trim(),28
      r = await signup(account, password, code, name)
      if _user r, account
        box.close()
        return
      r
  )
  return

< [
  MAIL
  (account)=>
    if not /^\S+@\S+$/.test(account)
      return

    [
      # 注册
      (up, password)=>
        send = => mail up, account, password
        r = await send()
        if r == 0
          _signup(account,password,send)
        if _user r, account
          return false
        r

      # 重置密码
      (password)=>
        reset = captcha resetPassword
        send = => reset(account, password)
        r = await send()
        # 返回的值可能是已登录
        if _user r, account
          return false

        switch r
          when 0
            _signup(account,password,send)
          when false
            box = _box(
              account,password,send
              {
                btn:RESET_PASSWORD
                next:(code) ->
                  r = await resetPassword(account, password, code)
                  if _user r, account
                    box.close()
                    setDone()
                    return
                  r
              }
            )
        return

      # 修改邮箱
      (UID,old,now)=>
        send = => setMail UID,now
        r = await send()
        if Number.isNaN r
          return false
        if r
          return (I18N)=>
            now + ' : ' + I18N[r]
        [box,tag] = tagBox('u-set-mail')
        new Promise (resolve, reject)=>
          x = =>
            box.close()
            return
          On box,{
            close:=>
              resolve(false)
              return
          }
          assign tag,{
            UID
            old
            now
            send
            ok: (r)=>
              resolve r
              x()
              return
          }
          return
    ]
]

