> @iuser/kebab
  utax/split.js
  path > join
  ./env > SRC
  fs > existsSync writeFileSync
  @iuser/replace
  @iuser/snake > SNAKE

import * as I18N_CODE from '../src/gen/i18n.js'

styl = 'styl/'
ext = 'styl'

# https://svelte.dev/docs#compile-time-svelte-preprocess
LI = [
  (code, filename)=> # i18n

    code = replace(
      code
      '<template lang="pug">'
      '</template>'
      (pug)=>
        pug.replaceAll(
          /(['"\s\(]|\|\s)>([\w_]+)/g
          (m,p1,p2)=>
            "#{p1}{I18N[#{I18N_CODE[SNAKE p2]}]}"
        )
    )

    code = replace(
      code
      '<script lang="coffee">'
      '</script>'
      (txt)=>
        + exist_submit

        txt = txt.replace(
          /^submit\s*=\s*[-=]>/gm
          (line)=>
            exist_submit = true
            li = split line,'='
            r = li.join('= _RUN ')
            r
        ).replace(
          /^on(Li|Me)([\s(])/mg
          (line)=>
            'onMount => '+line
        )

        mod = []

        if exist_submit
          mod.push './lib/_RUN.js:_RUN'

        hasI18n = /\bI18N\[/.test code
        if hasI18n
          mod.push './lib/_I18n.js > i18nOnMount'


        svelte_mod = new Set

        if hasI18n or /\bonMount\b/.test(txt)
          svelte_mod.add 'onMount'

        if /\btick\b/.test(txt)
          svelte_mod.add 'tick'

        if svelte_mod.size
          mod.push 'svelte > '+[...svelte_mod].join(' ')

        li = []
        if mod.length
          li.push '> '+mod.join('\n  ')

        if hasI18n
          li.push '''+ I18N'''

        li.push txt

        if hasI18n
          li.push '''\
  onMount i18nOnMount (o)=>
    I18N = o
    return\n'''
        li.join('\n')
      )
    code
  (code, filename)=> # web component
    name = filename[4..-8]
    key = kebab name
    fp = "#{styl}#{name}.#{ext}"
    path = join SRC,fp
    if not existsSync path
      writeFileSync(path,'')
    code + """<style lang="stylus">@import './#{fp}'</style><svelte:options tag="u-#{key}"/>"""

]

< ({ content:code, filename }) =>
  for i in LI
    code = i(code, filename)
  {
    code
  }
