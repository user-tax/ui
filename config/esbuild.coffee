> @iuser/walk > walkRel
  path > join extname dirname
  ./env > ROOT

external = []

for await i from walkRel(
  join(ROOT,'src')
  (i)=>
    i == 'styl'
)
  pos = i.lastIndexOf('.')
  if pos > 0
    ext = i[pos+1..]
    if ~ ['svelte','js','coffee',].indexOf ext
      external.push('./'+i[...pos]+'.js')

export default {
  external
  plugins: [
    #{
    #  name: 'alias',
    #  setup:(build) =>
    #    # we do not register 'file' namespace here, because the root file won't be processed https://github.com/evanw/esbuild/issues/791
    #    build.onResolve(
    #      { filter: /^~\/.*\.js$/ }
    #      (args) =>
    #        path = '.'+args.path[1..]
    #        console.log ">>>",path
    #        {
    #          path
    #          namespace:'~'
    #        }
    #    )
    #    return
    #}
  ]
}
