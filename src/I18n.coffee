#!/usr/bin/env coffee

> ./lib/I18n.js
  ./gen/I18N_VER.js
  ./lib/_I18n.js:_I18n

export default _I18n

< I18N_CDN = '//i18n.user.tax/'+I18N_VER+'/'

+ LANG, DEFAULT_LANG

L = localStorage

< set = (lang)=>
  if lang == DEFAULT_LANG
    delete L.lang
  else
    L.lang = lang
  LANG = lang
  return

< getLang = =>
  LANG

< get = (val_lang_li)=>
  map = new Map(val_lang_li)

  exist = (lang)=>
    if lang
      if not map.has(lang)
        lang = lang.split('-')[0]
        if not map.has(lang)
          return
      lang

  LANG = exist(L.lang)

  if not LANG
    for i in navigator.languages
      value = exist(i)
      if value
        DEFAULT_LANG = value
        break
    LANG = value or val_lang_li[0][0]
  LANG
