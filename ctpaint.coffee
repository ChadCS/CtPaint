toolbarHeight = 37
toolbarWidth = 52

canvasWidth = 256
canvasHeight = 256

canvasXPos = toolbarWidth+5
canvasYPos = 5
canvasXOffset = 0
canvasYOffset = 0

canvasAsData = undefined

selectedTool = undefined
numberOfTools = 24
toolViewMode = 0

mousePressed = false
draggingBorder = false

zoomActivate = false
cornersVisible = true

colorsAtHand = [ [192,192,192],[0,0,0],[255,255,255],[0,0,0] ]

xSpot = undefined
ySpot = undefined

oldX = undefined
oldY = undefined

xSpotZoom = undefined
ySpotZoom = undefined

oldXZoom = undefined
oldYZoom = undefined

selectLinesOfLengthX = []
selectLinesOfLengthY = []
dataToGive = [[255,255,255,255], [255,255,255,255], [255,255,255,255], [128,128,128,255]]
lineIndex = 0
while lineIndex < 4
  selectLinesOfLengthX.push document.createElement('canvas').getContext('2d').createImageData(lineIndex+1, 1)
  selectLinesOfLengthY.push document.createElement('canvas').getContext('2d').createImageData(1, lineIndex+1)
  dataIndex = 0
  while dataIndex < (lineIndex+1)
    eachColorIndex = 0
    while eachColorIndex < dataToGive.length
      selectLinesOfLengthX[selectLinesOfLengthX.length-1].data[eachColorIndex + (dataIndex * 4)] = dataToGive[dataIndex][eachColorIndex]
      selectLinesOfLengthY[selectLinesOfLengthY.length-1].data[eachColorIndex + (dataIndex * 4)] = dataToGive[dataIndex][eachColorIndex]
      eachColorIndex++
    dataIndex++
  lineIndex++

zeroPadder = (number,zerosToFill) ->
  numberAsString = number+''
  while numberAsString.length < zerosToFill
    numberAsString = '0'+numberAsString
  return numberAsString

rgbToHex = (rgb) ->
  return '#' + zeroPadder(rgb[0].toString(16),2) + zeroPadder(rgb[1].toString(16),2) + zeroPadder(rgb[2].toString(16),2)

ctCanvas = document.getElementById('CtPaint')
ctContext = ctCanvas.getContext('2d')

toolbar0Canvas = document.getElementById('toolbar0')
toolbar0Context = toolbar0Canvas.getContext('2d')

toolbar0sImages = [new Image(), new Image()]
toolbar0sImages[0].src = 'toolbar0v.PNG'
toolbar0sImages[1].src = 'toolbar0u.PNG'

buttonWidth = 24
buttonHeight = 24

keysToKeyCodes = 
  'backspace':8
  'tab':9
  'enter':13
  'shift':16
  'ctrl':17
  'alt':18
  'caps lock':20
  'escape':27
  'space':32
  'left':37
  'up':38
  'right':39
  'down':40
  'delete':46
  '0':48
  '1':49
  '2':50
  '3':51
  '4':52
  '5':53
  '6':54
  '7':55
  '8':56
  '9':57
  'a':65
  'b':66
  'c':67
  'd':68
  'e':69
  'f':70
  'g':71
  'h':72
  'i':73
  'j':74
  'k':75
  'l':76
  'm':77
  'n':78
  'o':79
  'p':80
  'q':81
  'r':82
  's':83
  't':84
  'u':85
  'v':86
  'w':87
  'x':88
  'y':89
  'z':90
  'left command':91
  'right command':93
  'numpad0':96
  'numpad1':97
  'numpad2':98
  'numpad3':99
  'numpad4':100
  'numpad5':101
  'numpad6':102
  'numpad7':103
  'numpad8':104
  'numpad9':105
  'f1':112
  'f2':113
  'f3':114
  'f4':115
  'f5':116
  'f6':117
  'f7':118
  'f8':119
  'f9':120
  'f10':121
  'f11':122
  'f12':123
  'semicolon':186
  'equals':187
  'comma':188
  'minus':189
  'period':190
  'forward slash':191
  'tilda':192
  'left bracket':219
  'back slash':220
  'right bracket':221
  'single quote':222

stringOfCharacters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ `.,;:'+"'"+'"?!0123456789@#$%^&*(){}[]'
stringsToGlyphs = {}
stringOfCharactersIndex = 0
varietyCodes = [ 'm', 'n', 'o' ]
while stringOfCharactersIndex < stringOfCharacters.length
  stringsToGlyphs[stringOfCharacters[stringOfCharactersIndex]] = [ new Image(), new Image(), new Image() ]
  imageVariety = 0
  while imageVariety < 3
    stringsToGlyphs[stringOfCharacters[stringOfCharactersIndex]][imageVariety].src = varietyCodes[imageVariety]+zeroPadder(stringOfCharactersIndex,4)+'.PNG'
    imageVariety++
  stringOfCharactersIndex++

drawStringAsCommandPrompt = (canvas, stringToDraw, coloration, whereAtX, whereAtY) ->
  stringIndex = 0
  while stringIndex < stringToDraw.length
    canvas.drawImage(stringsToGlyphs[stringToDraw[stringIndex]][coloration], whereAtX + (12 * stringIndex), whereAtY)
    stringIndex++

toolNames = ['zoom','select','sample','fill','square','circle','line','point']

zoomTransition = ->
  positionZoom()
  positionCorners()

zoomAction = ->
  if zoomActivate
    zoomActivate = false
    cornersVisible = true
    zoomTransition()
  else
    zoomActivate = true
    cornersVisible = false
    zoomTransition()
    canvasSectionToZoomAt = ctContext.getImageData(xSpot, ySpot, xSpot+Math.floor((window.innerWidth-toolbarWidth)/Math.pow(2,selectedTool.magnitude)), ySpot+Math.floor((window.innerHeight-toolbarHeight)/Math.pow(2,selectedTool.magnitude)) )
    zoomContext.putImageData(scaleImageBigger(canvasSectionToZoomAt,Math.pow(2,selectedTool.magnitude)),0,0)
    #  canvasSectionToPaste = ctContext.getImageData(0,0,10,10)
    #  zoomContext.putImageData(scaleImageBigger(canvasSectionToPaste,8),0,64)
    #  zoomContext.putImageData(canvasSectionToPaste,0,0)

selectAction = (canvas, beginX, beginY, endX, endY) ->
  #selectLine = document.createElement('canvas')
  #selectLinesData = selectLine.getContext('2d').createImageData(4, 1)
  console.log '1'

sampleAction = ->
  console.log '2'

fillAction = (canvas, context, colorToChangeTo, xPos, yPos) ->
  floodFill(canvas, context, colorToChangeTo, xPos, yPos)

squareAction = ->
  console.log '4'

circleAction = ->
  console.log '5'

lineAction = (canvas, color, beginX, beginY, endX, endY) ->
  drawLine(canvas, color, beginX, beginY, endX, endY)

pointAction = (canvas, color, beginX, beginY, endX, endY) ->
  drawLine(canvas, color, beginX, beginY, endX, endY)

ctPaintTools = {}

iteration = 0
while iteration < numberOfTools
  thisIteration = iteration
  ctPaintTools[iteration] =
    number: iteration
    name: toolNames[iteration]
    clickRegion: [((iteration%2)*25),(Math.floor(iteration/2))*25]
    pressedImage: [new Image(), new Image()]
    magnitude:1
    toolsAction: ->
      console.log toolNames, iteration, thisIteration
      console.log 'did a '+toolNames[@number]
  ctPaintTools[iteration].pressedImage[0].src = 'u'+zeroPadder(iteration,2)+'.PNG'
  ctPaintTools[iteration].pressedImage[1].src = 'v'+zeroPadder(iteration,2)+'.PNG'
  iteration++

ctPaintTools[7].toolsAction = pointAction
ctPaintTools[6].toolsAction = lineAction
ctPaintTools[0].toolsAction = zoomAction
ctPaintTools[3].toolsAction = fillAction

toolbar1Canvas = document.getElementById('toolbar1')
toolbar1Context = toolbar1Canvas.getContext('2d')
toolbar1sImage0 = new Image()
toolbar1sImage0.src = 'toolbar10.png'
toolbar1sImage1 = new Image()
toolbar1sImage1.src = 'toolbar11.png'
backgroundCanvas = document.getElementById('background')
backgroundContext = backgroundCanvas.getContext('2d')
zoomCanvas = document.getElementById('zoomWindow')
zoomContext = zoomCanvas.getContext('2d')

border0Canvas = document.getElementById('border0')
border0Context = border0Canvas.getContext('2d')
border1Canvas = document.getElementById('border1')
border1Context = border1Canvas.getContext('2d')
border2Canvas = document.getElementById('border2')
border2Context = border2Canvas.getContext('2d')
border3Canvas = document.getElementById('border3')
border3Context = border3Canvas.getContext('2d')

border0Context.canvas.width = 1
border0Context.canvas.height = 1
border1Context.canvas.width = 1
border1Context.canvas.height = 1
border2Context.canvas.width = 1
border2Context.canvas.height = 1
border3Context.canvas.width = 1
border3Context.canvas.height = 1

getColorValue = (canvas, whereAtX, whereAtY) ->
  return rgbToHex(canvas.getImageData(whereAtX, whereAtY, 1, 1).data)

putPixel = (canvas, color, whereAtX, whereAtY) ->
  newPixel = canvas.createImageData(1,1)
  newPixelsColor = newPixel.data
  newPixelsColor[0] = color[0]
  newPixelsColor[1] = color[1]
  newPixelsColor[2] = color[2]
  newPixelsColor[3] = 255
  canvas.putImageData(newPixel,whereAtX,whereAtY)

drawSelectLine = (canvas, beginX, beginY, endX, endY) ->
  if beginX > endX
    swapStorage = beginX
    beginX = endX
    endX = swapStorage
  if beginY > endY
    swapStorage = beginY
    beginY = endY
    endX = swapStorage
  distanceX = endX - beginX
  distanceY = endY - beginY
  while distanceX > 0
    if distanceX > 3
      canvas.putImageData(selectLinesOfLengthX[3],endX - distanceX, beginY)
      canvas.putImageData(selectLinesOfLengthX[3],endX - distanceX, endY)
      distanceX-=4
    else
      canvas.putImageData(selectLinesOfLengthX[distanceX - 1],endX - distanceX, beginY)
      canvas.putImageData(selectLinesOfLengthX[distanceX - 1],endX - distanceX, endY)
      distanceX-=distanceX
  while distanceY > 0
    if distanceY > 3
      canvas.putImageData(selectLinesOfLengthY[3], beginX, endY - distanceY)
      canvas.putImageData(selectLinesOfLengthY[3], endX, endY - distanceY)
      distanceY-=4
    else
      canvas.putImageData(selectLinesOfLengthY[distanceY - 1], beginX, endY - distanceY)
      canvas.putImageData(selectLinesOfLengthY[distanceY - 1], endX, endY - distanceY)

drawLine = (canvas, color, beginX, beginY, endX, endY) ->
  deltaX = Math.abs(endX - beginX)
  if beginX < endX
    directionX = 1
  else
    directionX = -1
  deltaY = Math.abs(endY - beginY)
  if beginY < endY
    directionY = 1
  else
    directionY = -1
  if deltaX > deltaY
    errorOne = deltaX/2
  else
    errorOne = -deltaY/2
  keepGoin = true
  while keepGoin
    putPixel(canvas,color,beginX,beginY)
    if (beginX == endX) and (beginY == endY)
      keepGoin = false
    errorTwo = errorOne
    if errorTwo > -deltaX
      errorOne -= deltaY
      beginX += directionX
    if errorTwo < deltaY
      errorOne += deltaX
      beginY += directionY

# The argument context is the context of the argument canvas.
# ColorToChangeTo is a three element array of color values 0<=.<255
# xFill and yFill are the coordates that the fill is initiated ( where
# the user clicks in my case)
floodFill = (canvas, context, colorToChangeTo, xPosition, yPosition) ->
  ###
  In my code, colors are given as (R,G,B), but the pixels in the canvas have an alpha channel, so I need
  to add an alpha value of 255
  ###
  colorToChangeTo.push 255

  ###
  Here is a function to simplify the code comparing two colors.
  Javascript (unlike python) doesnt allow comparing arrays, but 
  I can compare to values of the arrays to verify their equality.
  ###

  sameColorCheck = (firstColor, secondColor) ->
    return firstColor[0] == secondColor[0] and firstColor[1] == secondColor[1] and firstColor[2] == secondColor[2]

  ###
  (A)
  The the getImageData the puteImageData functions of the canvas are computationally taxing.
  In this flood fill function, the data, an array of color values, is first grabbed.
  Its far faster to manipulate an array than it is to manipulate the canvas element directly.

  (B)
  The checkAndFill pixel looks at each neighbor (north, east, west, and south), and sees if its
  the color to be replaced (colorToReplace). If it is colorToReplace, it then checks if its already
  in queue. Before doing any of that though, it checks to make sure there is in fact a northernly,
  easternly, westernly, southernly neighbor (by seeing if the element of the array is defined for
  the vertical directions, and if the pixel or its neighbor is 0 modulo canvas width for the
  horizontal directions). 

  (C)
  The while loop does checkAndFill for as long as there is an element in the queue. After it checks
  that pixel, it removes it from the array. For a normal region, pixelsToCheck fills up quickly as
  it touches many pixels with 2 or more available neighbors. Eventually the only members in 
  the queue have no available neighbors, and pixelsToCheck deflates.
  ###

  # (A)
  wholeCanvas = context.getImageData(0,0, canvas.width, canvas.height)
  wholeCanvasData = []
  canvasIndex = 0
  while canvasIndex < wholeCanvas.data.length
    wholeCanvasData.push wholeCanvas.data[canvasIndex]
    canvasIndex++
  wholeCanvas = wholeCanvasData

  # (B)    
  wholeCanvasAsPixels = []
  singlePixel = []
  canvasIndex = 0
  while canvasIndex < wholeCanvas.length
    singlePixel.push wholeCanvas[canvasIndex]
    if singlePixel.length == 4
      wholeCanvasAsPixels.push singlePixel
      singlePixel = []
    canvasIndex++
  wholeCanvas = wholeCanvasAsPixels

  originalPosition = xPosition + (yPosition * canvas.width)
  colorToReplace = wholeCanvas[originalPosition]

  ###
  (A)
  Below, each pixel is checked to see if its the colorToReplace. If it is the color is changed
  and the pixels neighbors are added to a queue of pixels to be checked. The queue is declared
  populated with the pixel that was clicked on.

  (B)
  The canvas elements data is just an array of color values. If the pixels are numbered, and 'R0' refers to the red value
  of pixel one. The canvases data looks like [ R0, G0, B0, A0, R1, G1, B1, A1, R2 ]. I decided to convert the array into
  an array of pixels for ease of coding, though I wonder if the program would be significantly faster if I worked with 
  just the array.

  (C)
  Since we are working with a one dimensional array of pixels. The (x,y) coordinates no longer make sense.
  originalPosition is the position in the one dimensional array translated from the two dimenstional (x,y)
  coordinates. colorToReplace is the color we are replacing, and its the color at originalPosition.
  ###

  # (A)
  pixelsToCheck = [originalPosition]

  # (B)
  checkAndFill = (pixelIndex)->
    if typeof wholeCanvas[ pixelIndex - canvas.width ] != 'undefined'
      if sameColorCheck(colorToReplace, wholeCanvas[pixelIndex - canvas.width])
        if (pixelsToCheck.indexOf(pixelIndex - canvas.width) == -1)
          pixelsToCheck.push (pixelIndex - canvas.width)
          wholeCanvas[pixelIndex - canvas.width] = colorToChangeTo
    if (pixelIndex + 1)%canvas.width != 0 
      if sameColorCheck(colorToReplace, wholeCanvas[pixelIndex + 1])
        if (pixelsToCheck.indexOf(pixelIndex + 1) == -1)
          pixelsToCheck.push (pixelIndex + 1)
          wholeCanvas[pixelIndex + 1] = colorToChangeTo
    if typeof wholeCanvas[pixelIndex + canvas.width] != 'undefined'
      if sameColorCheck(colorToReplace, wholeCanvas[pixelIndex + canvas.width])
        if pixelsToCheck.indexOf(pixelIndex + canvas.width) == -1
          pixelsToCheck.push (pixelIndex + canvas.width)
          wholeCanvas[pixelIndex + canvas.width] = colorToChangeTo
    if (pixelIndex)%canvas.width != 0
      if sameColorCheck(colorToReplace, wholeCanvas[pixelIndex - 1])
        if (pixelsToCheck.indexOf(pixelIndex - 1) == -1)
          pixelsToCheck.push (pixelIndex - 1)
          wholeCanvas[pixelIndex - 1] = colorToChangeTo

  # (C)
  while pixelsToCheck.length
    checkAndFill(pixelsToCheck[0])
    pixelsToCheck.splice(0,1)

  ###
  revisedCanvasToPaste is a new canvas, that is the same size of the canvas that was read.
  The manipulated data of the original canvas is then put into the revised canvas and the
  revised canvas is pasted over the old.
  ###

  revisedCanvasToPaste = document.createElement('canvas').getContext('2d').createImageData(canvas.width, canvas.height)

  pixelInCanvasIndex = 0
  while pixelInCanvasIndex < wholeCanvas.length
    colorValueIndex = 0
    while colorValueIndex < wholeCanvas[pixelInCanvasIndex].length
      revisedCanvasToPaste.data[(pixelInCanvasIndex * 4) + colorValueIndex] = wholeCanvas[pixelInCanvasIndex][colorValueIndex]
      colorValueIndex++
    pixelInCanvasIndex++

  context.putImageData(revisedCanvasToPaste,0,0)  
  
positionCorners = ->
  if cornersVisible
    $('#border0Div').css('top',(canvasYPos-1+canvasYOffset).toString())
    $('#border0Div').css('left',(canvasXPos-1+canvasXOffset).toString())

    $('#border1Div').css('top',(canvasYPos-1+canvasYOffset).toString())
    $('#border1Div').css('left',(canvasXPos+canvasWidth+1+canvasXOffset).toString())

    $('#border2Div').css('top',(canvasYPos+canvasHeight+1+canvasYOffset).toString())
    $('#border2Div').css('left',(canvasXPos+canvasWidth+1+canvasXOffset).toString())

    $('#border3Div').css('top',(canvasYPos+canvasHeight+1+canvasYOffset).toString())
    $('#border3Div').css('left',(canvasXPos-1+canvasXOffset).toString())
  
  else
    $('#border0Div').css('top',(window.innerHeight).toString())
    $('#border0Div').css('left',(canvasXPos-1+canvasXOffset).toString())

    $('#border1Div').css('top',(window.innerHeight).toString())
    $('#border1Div').css('left',(canvasXPos+canvasWidth+1+canvasXOffset).toString())

    $('#border2Div').css('top',(window.innerHeight).toString())
    $('#border2Div').css('left',(canvasXPos+canvasWidth+1+canvasXOffset).toString())

    $('#border3Div').css('top',(window.innerHeight).toString())
    $('#border3Div').css('left',(canvasXPos-1+canvasXOffset).toString())  

positionCanvas = ->
  $('#ctpaintDiv').css('top', (canvasYPos+canvasYOffset).toString())
  $('#ctpaintDiv').css('left',(canvasXPos+canvasXOffset).toString())

prepareCanvas = ->
  ctContext.canvas.width = canvasWidth
  ctContext.canvas.height = canvasHeight

  ctContext.fillStyle = '#000000'
  ctContext.fillRect(0,0,canvasWidth,canvasHeight)

  positionCanvas()
  positionCorners()

positionZoom = ->
  if zoomActivate
    $('#zoomDiv').css('top', '0')
    $('#zoomDiv').css('left', toolbarWidth.toString())

    zoomContext.canvas.width = window.innerWidth - toolbarWidth
    zoomContext.canvas.height = window.innerHeight - toolbarHeight

  else
    $('#zoomDiv').css('top', window.innerHeight)
    $('#zoomDiv').css('left', toolbarWidth.toString())

    zoomContext.canvas.width = 1
    zoomContext.canvas.height = 1

setCanvasSizes = ->
  toolbar0Context.canvas.width = toolbarWidth
  toolbar0Context.canvas.height = window.innerHeight-toolbarHeight

  toolbar1Context.canvas.width = window.innerWidth
  toolbar1Context.canvas.height = toolbarHeight

  backgroundContext.canvas.width = window.innerWidth
  backgroundContext.canvas.height = window.innerHeight

placeToolbars = ->
  $('#toolbar0Div').css('top', '0')
  $('#toolbar1Div').css('top', (window.innerHeight-toolbarHeight).toString())

drawToolbars = ->
  toolbar0Context.fillStyle = '#202020'
  toolbar0Context.fillRect(0,0,toolbarWidth,window.innerHeight-toolbarHeight)
  toolbar0Context.drawImage(toolbar0sImages[toolViewMode],0,0)
  drawLine(toolbar0Context,[16,20,8],toolbarWidth-1,0,toolbarWidth-1,window.innerHeight-toolbarHeight)
  if selectedTool
    toolbar0Context.drawImage(selectedTool.pressedImage[toolViewMode],selectedTool.clickRegion[0],selectedTool.clickRegion[1])

  toolbar1Context.fillStyle = '#202020'
  toolbar1Context.fillRect(0,0,window.innerWidth,toolbarHeight)

  toolbar1Context.drawImage(toolbar1sImage0,3,2)
  drawLine(toolbar1Context,[16,20,8],toolbarWidth-1,0,window.innerWidth,0)
  toolbar1Context.drawImage(toolbar1sImage1,188,3)
  drawLine(toolbar1Context,[16,20,8],toolbarWidth-1,0,window.innerWidth,0)

  toolbar1Context.fillStyle = rgbToHex(colorsAtHand[0])
  toolbar1Context.fillRect(7,4,14,14)

  toolbar1Context.fillStyle = rgbToHex(colorsAtHand[1])
  toolbar1Context.fillRect(24,4,14,14)

  toolbar1Context.fillStyle = rgbToHex(colorsAtHand[2])
  toolbar1Context.fillRect(16,21,14,14)

  toolbar1Context.fillStyle = rgbToHex(colorsAtHand[2])
  toolbar1Context.fillRect(33,21,14,14)

drawInformation = ->
  drawLine(toolbar1Context,[16,20,8],toolbarWidth-1,0,window.innerWidth,0)
  drawStringAsCommandPrompt(toolbar1Context, getColorValue(ctContext, event.clientX - (toolbarWidth + 5) - canvasXOffset, event.clientY - 5 - canvasYOffset).toUpperCase() + ', (' + (event.clientX - (toolbarWidth + 5) - canvasXOffset).toString() + ', ' + (event.clientY - 5 - canvasYOffset).toString() + ')', 0, 191, 12)
  #drawStringAsCommandPrompt = (canvas, stringToDraw, coloration, whereAtX, whereAtY) ->

getMousePositionOnCanvas = (event) ->
  xSpot = event.clientX - (toolbarWidth+5) - canvasXOffset
  ySpot = event.clientY - 5 - canvasYOffset

getMousePositionOnZoom = (event) ->
  xSpotZoom = event.clientX - (toolbarWidth)
  ySpotZoom = event.clientY - (toolbarHeight)

scaleImageBigger = (imageData,factor) ->
  imageHeight = imageData.height
  imageWidth = imageData.width
  imageDatasData = imageData.data

  outputsHeight = imageHeight*factor
  outputsWidth = imageWidth*factor

  outputImage = []
  arrayOfPixels = []
  arrayOfRows = []
  singleRow = []
  singlePixel = []

  datumIndex = 0
  while datumIndex < imageDatasData.length
    singlePixel.push imageDatasData[datumIndex]
    if singlePixel.length == 4
      singleRow.push singlePixel
      singlePixel = []
    if singleRow.length == imageWidth
      arrayOfRows.push singleRow
      singleRow = []
    datumIndex++

  rowIndex = 0
  while rowIndex < arrayOfRows.length
    throwAwayArray = []
    pixelIndex = 0
    while pixelIndex < arrayOfRows[rowIndex].length
      pixelIteration = 0
      while pixelIteration < factor
        throwAwayArray.push arrayOfRows[rowIndex][pixelIndex]
        pixelIteration++
      pixelIndex++
    arrayOfRows[rowIndex] = throwAwayArray
    rowIndex++

  rowIndex = 0
  while rowIndex < arrayOfRows.length
    rowIteration = 0
    while rowIteration < factor
      pixelIndex = 0
      while pixelIndex < arrayOfRows[rowIndex].length
        colorDatumIndex = 0
        while colorDatumIndex < 4
          outputImage.push arrayOfRows[rowIndex][pixelIndex][colorDatumIndex]
          colorDatumIndex++
        pixelIndex++
      rowIteration++
    rowIndex++

  scaledImage = document.createElement('canvas')
  scaledImageData = scaledImage.getContext('2d').createImageData(outputsWidth, outputsHeight)

  outputImageIndex = 0
  while outputImageIndex < outputImage.length
    scaledImageData.data[outputImageIndex] = outputImage[outputImageIndex]
    outputImageIndex++

  return scaledImageData

$(document).ready ()->
  setTimeout( ()->
    setCanvasSizes()
    prepareCanvas()
    placeToolbars()
    selectedTool = ctPaintTools[7]
    drawToolbars()
    positionZoom()
    canvasAsData = ctCanvas.toDataURL()
  , 2000)

  #setTimeout( ()->
  #  canvasSectionToPaste = ctContext.getImageData(0,0,10,10)
  #  zoomContext.putImageData(scaleImageBigger(canvasSectionToPaste,8),0,64)
  #  zoomContext.putImageData(canvasSectionToPaste,0,0)
  #,5000)

  $('body').keydown (event) ->
    if event.keyCode == keysToKeyCodes['1']
      selectedTool = ctPaintTools[0]
      drawToolbars()
    if event.keyCode == keysToKeyCodes['2']
      selectedTool = ctPaintTools[1]
      drawToolbars()
    if event.keyCode == keysToKeyCodes['3']
      selectedTool = ctPaintTools[2]
      drawToolbars()
    if event.keyCode == keysToKeyCodes['4']
      selectedTool = ctPaintTools[3]
      drawToolbars()
    if event.keyCode == keysToKeyCodes['5']
      selectedTool = ctPaintTools[4]
      drawToolbars()
    if event.keyCode == keysToKeyCodes['6']
      selectedTool = ctPaintTools[5]
      drawToolbars()
    if event.keyCode == keysToKeyCodes['7']
      selectedTool = ctPaintTools[6]
      drawToolbars()
    if event.keyCode == keysToKeyCodes['8']
      selectedTool = ctPaintTools[7]
      drawToolbars()

    if event.keyCode == keysToKeyCodes['up']
      if canvasHeight > (window.innerHeight - toolbarHeight - 5)
        if canvasYOffset < 0 
          canvasYOffset+=3
          positionCanvas()
          positionCorners()
    if event.keyCode == keysToKeyCodes['down']
      if canvasHeight > (window.innerHeight - toolbarHeight - 5)
        if (-1 * canvasYOffset) < ((canvasHeight + 10) - (window.innerHeight - toolbarHeight))
          canvasYOffset-=3
          positionCanvas()
          positionCorners()
    if event.keyCode == keysToKeyCodes['right']
      if canvasWidth > (window.innerWidth - toolbarWidth - 5)
        if (-1 * canvasXOffset) < ((canvasWidth + 10) - (window.innerWidth - toolbarWidth))
          canvasXOffset-=3
          positionCanvas()
          positionCorners()
    if event.keyCode == keysToKeyCodes['left']
      if canvasWidth > (window.innerWidth - toolbarWidth - 5)
        if canvasXOffset < 0
          canvasXOffset+=3
          positionCanvas()
          positionCorners()
    if event.keyCode == keysToKeyCodes['alt']
      toolViewMode++
      toolViewMode = toolViewMode%2
      drawToolbars()
    if event.keyCode == keysToKeyCodes['equals']
      selectedTool.magnitude++
    if event.keyCode == keysToKeyCodes['minus']
      selectedTool.magnitude--
 
  $(window).resize ()->
    if canvasWidth < (window.innerWidth - toolbarWidth - 5)
      canvasXOffset = 0
    if canvasHeight < (window.innerHeight - toolbarHeight - 5)
      canvasYOffset = 0
    positionCanvas()
    positionCorners()
    setCanvasSizes()
    placeToolbars()
    drawToolbars()
    positionZoom()

  $(window).scroll ()->
    window.scroll(0,0)

  window.onmousemove = () ->
    if (event.clientX < (canvasWidth + 5 + toolbarWidth + 20)) and ((canvasWidth + 5 + toolbarWidth) < event.clientX)
      if (event.clientY < (canvasHeight + 5 + 20)) and ((canvasHeight + 5) < event.clientY)
        $('#wholeWindow').css 'cursor', 'se-resize'
    else
      $('#wholeWindow').css 'cursor', 'default'

  window.onmousedown = (event)->
    if (event.clientX < (canvasWidth + 5 + toolbarWidth + 20)) and ((canvasWidth + 5 + toolbarWidth) < event.clientX)
      if (event.clientY < (canvasHeight + 5 + 20)) and ((canvasHeight + 5) < event.clientY)
        canvasAsData = ctCanvas.toDataURL()
        oldX = event.clientX
        oldY = event.clientY
        draggingBorder = true

  window.onmouseup = (event) ->
    if draggingBorder
      draggingBorder = false
      ctContext.canvas.width = event.clientX - oldX + canvasWidth
      ctContext.canvas.height = event.clientY - oldY + canvasHeight
      canvasDataAsImage = new Image()
      canvasDataAsImage.onload = ->
        ctContext.drawImage(canvasDataAsImage,0,0)
        canvasAsData = ctCanvas.toDataURL()
        canvasDataAsImage = new Image()
        canvasDataAsImage.src = canvasAsData
      canvasDataAsImage.src = canvasAsData
      ctContext.fillStyle = rgbToHex(colorsAtHand[1])
      if (ctContext.canvas.width > canvasWidth) and (ctContext.canvas.height > canvasHeight)
        ctContext.fillRect(canvasWidth, 0, ctContext.canvas.width, ctContext.canvas.height)
        ctContext.fillRect(0, canvasHeight, canvasWidth, ctContext.canvas.height)
      else if (ctContext.canvas.width > canvasWidth)
        ctContext.fillRect(canvasWidth, 0, ctContext.canvas.width, ctContext.canvas.height)
      else if (ctContext.canvas.height > canvasHeight)
        ctContext.fillRect(0, canvasHeight, ctContext.canvas.width, ctContext.canvas.height)
      canvasWidth = ctContext.canvas.width
      canvasHeight = ctContext.canvas.height
      positionCorners()
      $('#wholeWindow').css 'cursor', 'default'   

  $('#CtPaint').mouseleave ()->  
    toolbar1Context.drawImage(toolbar1sImage1,188,3)   

  $('#CtPaint').mousemove (event)->
    toolbar1Context.drawImage(toolbar1sImage1,188,3)   
    drawInformation()
    switch selectedTool.name
      when 'select'
        if mousePressed
          getMousePositionOnCanvas(event)
          selectedTool.toolsAction(ctContext, oldX, oldY, xSpot, ySpot)
      when 'line'
        if mousePressed
          getMousePositionOnCanvas(event)
          canvasDataAsImage = new Image()
          canvasDataAsImage.onload = ->
            ctContext.drawImage(canvasDataAsImage,0,0)
            selectedTool.toolsAction(ctContext, colorsAtHand[0], oldX, oldY, xSpot, ySpot)
          canvasDataAsImage.src = canvasAsData
      when 'point'
        if mousePressed
          oldX = xSpot
          oldY = ySpot
          getMousePositionOnCanvas(event)
          selectedTool.toolsAction(ctContext, colorsAtHand[0], xSpot, ySpot, oldX, oldY)

  $('#CtPaint').mousedown (event)->
    mousePressed = true
    getMousePositionOnCanvas(event)
    switch selectedTool.name
      when 'zoom'
        selectedTool.toolsAction()
      when 'fill'
        selectedTool.toolsAction(ctCanvas, ctContext, colorsAtHand[0], xSpot, ySpot)
      when 'select'
        oldX = xSpot
        oldY = ySpot
      when 'line'
        oldX = xSpot
        oldY = ySpot
      when 'point'
       selectedTool.toolsAction(ctContext, colorsAtHand[0], xSpot, ySpot, xSpot, ySpot)

  $('#CtPaint').mouseup (event)->
    mousePressed = false
    switch selectedTool.name
      when 'select'
        selectedTool.toolsAction()
      when 'line'
        canvasAsData = ctCanvas.toDataURL()
      when 'point'
        canvasAsData = ctCanvas.toDataURL()

  #$('#background').mousemove ()->
  #  toolbar1Context.drawImage(toolbar1sImage1,188,3) 

  #$('toolbar0').mousemove ()->
  #  toolbar1Context.drawImage(toolbar1sImage1,188,3) 

  #$('toolbar1').mousemove ()->
  #  toolbar1Context.drawImage(toolbar1sImage1,188,3) 

  $('#zoomWindow').mousedown (event)->
    mousePressed = true
    switch selectedTool.name
      when 'zoom'
        selectedTool.toolsAction()

  $('#toolbar0').mousedown (event)->
    toolIndex = 0
    while toolIndex < numberOfTools
      if ctPaintTools[toolIndex].clickRegion[0]<event.clientX and event.clientX<(ctPaintTools[toolIndex].clickRegion[0]+buttonWidth)
        if ctPaintTools[toolIndex].clickRegion[1]<event.clientY and event.clientY<(ctPaintTools[toolIndex].clickRegion[1]+buttonHeight)
          selectedTool = ctPaintTools[toolIndex]
      toolIndex++
    drawToolbars()

    









