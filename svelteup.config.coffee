> ./config/esbuild
  ./config/markup
  ./package.json:pkg
  ./config/postcss
  @iuser/svelte-preprocess
  path > join dirname
  ./config/env > DEV

IGNORE_WARN = new Set(
  'a11y-click-events-have-key-events a11y-missing-content'.split(' ')
)
< {
  entry: 'src/index.js'
  outdir: 'lib'
  sourcemap: DEV # true
  servedir: '.'
  compilerOptions: {
    css: 'external'
    customElement: true
  }
  esbuild
  onwarn: (warn) =>
    {code,message} = warn
    if code == 'a11y-missing-attribute'
      return !message.includes('<a>')
    !IGNORE_WARN.has code
  preprocess: [
    # style: ({ content, attributes, filename }) =>
    #  #if attributes.lang != 'stylus'
    #  #  return
    #  {css} = await postcss.process(content,{from:filename})
    #  return {
    #    code:css
    #  }
    {
      markup
    }
    SveltePreprocess({
      sourceMap: true
      coffeescript: {
        label:true
        sourceMap: true
      }
      stylus: true
      pug: true
      postcss
    })
  ]
}
