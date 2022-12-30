#!/usr/bin/env coffee

> utax/split

import {writeFile} from 'fs/promises'
import fsline from '@rmw/fsline'
import thisdir from '@rmw/thisdir'
import {SRC, LIB_INDEX} from './env'
import {join} from 'path'
import {upperFirst,camelCase} from 'lodash-es'

pug_i = (name)->
  pug_begin = false
  fp = join(SRC,name+'.svelte')
  has_sdk = false
  for await sl from fsline fp
    sl = sl.trim()
    if pug_begin
      if sl == '</template>'
        break
      if sl.startsWith 'u-'
        yield 'u'+upperFirst(camelCase(sl[2..].split('(',1)[0]))+'();'
    else if sl.startsWith('<template lang=') and ~ sl.indexOf('pug')
      pug_begin = true

  return


svelte_module = (iter)->
  for await line from iter
    if line.startsWith('var ')
      if ~ line.indexOf('class extends')
        line = 'const '+line[4..]

    else if line.startsWith 'customElements.define("'
      t = line[23..]
      pos = t.indexOf('-')+1
      p2 = t.indexOf(',',pos)
      name = t[pos...p2-1]
      cls = t[p2+1..-3].trim()

      need = Array.from(i for await i from pug_i(cls)).join('')

      line = """export const u#{cls}=()=>{ if(customElements.get(UI_PREFIX+'#{name}'))return; #{need} return $ELEMENT("#{name}",#{cls}) } """
    yield line

i18n = (iter)->
  yield "import { i18nOnMount } from './lib/_I18n.js';"
  for await line from iter
    line = line.replace /i18nOnMount\d+\(/,'i18nOnMount('
    line = line.replace(/:global\(([^\)]+)\)/g,'$1')
    if line.endsWith '} from "./lib/_I18n.js";'
      continue
    else
      yield line

await do =>
  UI_PREFIX = "const UI_PREFIX = 'u-';"
  li = [
    UI_PREFIX
    '''function $ELEMENT(name,o) {
      return customElements.define(UI_PREFIX+name,o)
    }'''
  ]
  n = 0
  for await line from i18n svelte_module fsline(LIB_INDEX)
    if n == 0
      if line == UI_PREFIX
        return
    ++n
    li.push line
  await writeFile LIB_INDEX, li.join('\n').replaceAll(
    '"u-'
    'UI_PREFIX+"'
  )

