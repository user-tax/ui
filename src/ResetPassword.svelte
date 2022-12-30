<template lang="pug">
include pug/p_input.pug
form(@&form @submit|preventDefault)
  +p_input("{tip}")#account(&account required)
  +p_input(">setPassword")#password(
    &password
    minlength="6"
    required
    type="password"
  )
  button(type="submit") >resetPassword
</template>

<script lang="coffee">
> ./gen/i18n.js > ACCOUNT_INVALID
  ./auth/WAY.js > accountWay
  ./lib/AutoFocus.js

+ form

< tip, account, next,  password

submit = =>
  f = await accountWay(account,1)
  if f
    await f(password)
    next()
  throw account:ACCOUNT_INVALID
  return

onMount =>
  return AutoFocus(form)
</script>
