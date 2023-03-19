#!/usr/bin/env coffee

> @u7/read
  @u7/write
  ./env > SRC LIB_INDEX
  @u7/default:

PREFIX = '_CSS_'

cssIter = (css)->
  t = []
  n = 0
  for i from css
    if i == '}'
      --n
      if not n
        yield t.join('')+'}'
        t = []
        continue

    if i == '{'
      ++n
    t.push i

  if t.length
    yield t.join('')
  return

do =>
  li = read(LIB_INDEX).split('\n')

  pos_set = new Set()

  for line,pos in li
    i = line.trim()
    prefix = 'style.textContent = `'
    if i.startsWith prefix
      # for j from cssIter
      for j from cssIter i[prefix.length..-3]
        console.log j
  # split = 'style>'
  #
  # css = new Map()
  # pos_set = new Set()
  #
  # n = 0
  # for line,pos in li
  #   if line.endsWith('</') and li[pos+1].startsWith('`')
  #     pos_set.add pos
  #     for i from cssIter line[..-3]
  #       if i
  #         css.get_default(
  #           i
  #           new Set()
  #         ).add pos
  #
  # line_css = new Map
  #
  # for [k,v] from css.entries()
  #   if v.size == 1
  #     css.delete k
  #   else
  #     v = [...v].sort((a,b)=>a-b)
  #     v = v.join('_')
  #     css.set k, v
  #     line_css.get_default(v,[]).push k
  #
  # varinit = []
  # for [k,v] from line_css.entries()
  #   v = v.join('')
  #   s = '\''
  #   if v.includes(s)
  #     s = '"'
  #     if v.includes s
  #       s = '`'
  #   varinit.push PREFIX+k+'='+s+v+s
  #
  # for pos from pos_set
  #   exist = new Set
  #   t = []
  #   for i from cssIter li[pos][..-3]
  #     if i
  #       varname = css.get i
  #       if varname
  #         if not exist.has varname
  #           exist.add varname
  #           t.push '${'+PREFIX+varname+'}'
  #       else
  #         t.push i
  #   li[pos] = t.join('')+'</'
  #
  # li = li.join(split)
  #
  # li = li.replaceAll(
  #   'this.shadowRoot.innerHTML = `<style>'
  #   '__style__(this,`'
  # ).replaceAll('</style>`','`)')
  # varinit = varinit.join(',')
  # if varinit
  #   varinit = ','+varinit
  # write LIB_INDEX, 'const __style__=(e,i)=>e.shadowRoot.innerHTML=`<style>${i}</style>`'+varinit+';'+li
  return
