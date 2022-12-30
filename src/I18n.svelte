<template lang="pug">
+if val_lang_li
  select.ico(&lang)
    +each val_lang_li as i
      option(value="{ i[0] }") {i[1]}
</template>

<script lang="coffee">
> svelte/internal > noop
  ./I18n.js > set get
  ./lib/str2li.js

< li
< change = noop

+ val_lang_li,lang


:$
  if li
    val_lang_li = str2li li.split('|')

:$
  if lang
    set lang
    change lang
  else if val_lang_li
    lang = get val_lang_li
</script>

