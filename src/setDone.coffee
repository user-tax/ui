> ./Box.js > tagBox
  ./lib/byTag.js > byTag0

< =>
  [box,tag] = tagBox 'u-set-done'
  tag.click = =>
    box.close()
    return
  return
