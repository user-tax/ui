<template lang="pug">
template(@&Drop)
  ul
    slot(name="ul")
    li >config
    li >switchUser
    li >logout
u-if-user
  span(@click=drop) {user.name}
  slot(slot="else")
</template>

<script lang="coffee">
> ./User.js > onMe exit
  ./lib/SDK.js
  ./lib/menu.js
  ./lib/bindLi.js
  ./sign.js
  ./conf.js

+ Drop, drop

< auth

user = {}

onMount =>
  drop = menu Drop, bindLi(
    =>
      conf user.id
      return
    =>
      auth sign()
      return
    exit
  )

onMe (u)=>
  user = u
  return
</script>
