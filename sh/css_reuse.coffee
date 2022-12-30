#!/usr/bin/env coffee

import {SRC, LIB_INDEX} from './env'
import {readFile, writeFile} from 'fs/promises'
import 'get_default'

comm = new Map()

fsli = []

PREFIX = 'this.shadowRoot.innerHTML = '

await do =>
  t = ''
  for line in (await readFile LIB_INDEX,'utf8').split('\n')
    if line.trim().startsWith PREFIX
      if not line.endsWith('`;')
        t = line
        continue
    else if t
      t+=line
      if t.endsWith('`;')
        line = t
        t = ''
      else
        continue

    fsli.push line


keyer = (li)=>li.join('_')

begin_end = (line)=>
  if ~ line.indexOf(PREFIX)
    pos = line.indexOf('<style>')
    if pos > 0
      pos+=7
      end = line.indexOf('</style>',pos)-1
      return [pos,end]


for line,n in fsli
  r = begin_end(line)
  if r
    [begin, end] = r
    for line from line[begin..end].split('}')
      if line
        comm.get_default(line,[]).push n

extract = new Map()
exist_line_number = new Set()
for [k,li] from comm.entries()
  s = new Set(li)
  if s.length < li.length
    console.log "🔥 #{LIB_INDEX}:#{li.join(',')} css repeat",k
  if s.size > 1
    li = [...s]
    li.map(exist_line_number.add.bind(exist_line_number))
    li.sort()
    key = keyer li
    comm.set(k,key)
    extract.get_default(key,[]).push(k)
  else
    comm.delete(k)

do ->
  prefix = 'CSS_'
  for line_no from exist_line_number
    line = fsli[line_no]
    [begin,end] = begin_end line
    need = new Set()
    r = []
    for i from line[begin..end].split('}')
      key = comm.get(i)
      if key
        need.add(key)
        continue
      else
        r.push i
    if need.size
      begin = line[...begin].trim()
      end = line[end+1..]
      line = '${'+prefix+[...need].join(prefix)+'}'+r.join('}')
      #if begin == PREFIX+'`<style>' and end == '</style>`;'
      #  begin = '    innerStyle(this,`'
      #  end = '`);'
      fsli[line_no] = begin + line + end

  li = []
  for [k,v] from extract.entries()
    v = v.join('}')+'}'
    for q from '"\'`'
      if v.indexOf(q) < 0
        break
    li.push """CSS_#{k}=#{q}#{v}#{q}"""
  writeFile(
    LIB_INDEX
    'const '+li.join(',')+';\n'+fsli.join('\n')
    # +'''
    # function innerStyle(self,style) {
    #   self.shadowRoot.innerHTML = `<style>${style}</style>`
    # }
    # '''
  )
  return

