<script lang="coffee">
> ./utax/On.js
  ./lib/errRender.js
  ./lib/Focus.js
  ./lib/AutoFocus.js
  ./auth/WAY.js:@ > accountWay
  ./gen/i18n.js > PASSWORD SET_PASSWORD CLICK_SIGN_IN ACCOUNT_EXIST ACCOUNT_MAIL_HOST_BAN ERR_ACCOUNT_OR_PASSWORD ACCOUNT_INVALID
  ./lib/byTag.js:@ > byTagBind byTag0
  ./setPassword.js

< agree
< next = =>
< account = ''

+ form, errAccount, errPassword, inputLi, focus

+ password = tip = ''

:$
  if Array.isArray(I18N)
    tip = (
      WAY.map ([k,func])=>
        I18N[k]
    ).join ' / '

< up = ! account

submit = =>
  account = account.trim()
  errAccount = account
  errPassword = password
  r = await accountWay(account,0)
  if r
    r = await errRender(
      r(up, password[..63])
      (err)=>
        if err.account == ACCOUNT_EXIST
          err.account = (b)=>
            b.innerText = I18N[ACCOUNT_EXIST]
            a = document.createElement 'a'
            a.innerText = I18N[CLICK_SIGN_IN]
            On a,{
              click:=>
                up = undefined
                b.remove()
                focus()
                return
            }
            b.appendChild a
            return
        return
    )

    if Number.isNaN r
      focus()
      return
    if r != undefined
      if not r
        next()
        return
      return
  throw account:ACCOUNT_INVALID
  inputFocus 0
  return

inputFocus = (n)=>
  i = inputLi()[n]
  i.focus()
  i.select()
  return

isAgree = true

:$
  i18nPassword = I18N[if up then SET_PASSWORD else PASSWORD]

onMount =>
  inputLi = byTagBind form, 'input'
  focus = Focus form
  for i from inputLi()
    On(
      i
      keydown:(e)=>
        if 13 == e.keyCode
          e.preventDefault()
          for b from byTag form,'button'
            if b.className != 'a'
              b.click()
              break
        return
    )
  return AutoFocus form


signup = (e)=>
  if !up
    e.preventDefault()
    up = 1
    i = inputLi()
    for x from i
      x.value = ''
    i[0].focus()
  return

signin = (e)=>
  if up
    e.preventDefault()
    up = undefined
    [i0,i1] = inputLi()
    if not i0.value
      i0.value = account
      i1.value = ''
    focus()
  return


resetPassword = =>
  setPassword(
    tip
    account
    password
    =>
      account = e.account
      password = e.password
      return
  )
  return

</script>

<template lang="pug">
include pug/p_input.pug
form(@&form @submit|preventDefault)
  +p_input("{tip}")#account(
    &account
    autocomplete="{ up ? 'off' : null }"
    required
  )
  +p_input("{i18nPassword}")#password(
    &password
    minlength="6"
    required
    type="password"
  )
  p
    +if isAgree
      button(@click=signup class:a=!up type="submit")
        | >signUp
      button(@click=signin class:a=up type="submit")
        | >signIn
      +else
        b >needUserAgreement
  footer
    p
      input#uAuthAgree(checked&isAgree type="checkbox")
      label(for="uAuthAgree") >agree
      a(@click=agree) >userAgreement
    a(@click=resetPassword) >resetPassword
</template>
