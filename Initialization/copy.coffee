copyAction = ->
  tH.push ctPaintTools[18]
  drawToolbars()

  if areaSelected
    copyMemory = selection
  else
    copyMemory = ctContext.getImageData(0, 0, ctContext.canvas.width, ctContext.canvas.height)
  copyExists = true

  setTimeout( ()->
    tH.pop()
    drawToolbars()
  ,20)