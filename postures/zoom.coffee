zoomPosture = [
  (event) ->
    drawInformation(event)
    setCasualPosition(event)
    #updateCursor(event)

  (event) ->
    if not mousePressed
      mousePressed = true
      getMousePositionOnCanvas(event)
      zoomAction(xSpot, ySpot)

  (event) ->
    if mousePressed
      mousePressed = false

  (event) ->
]

