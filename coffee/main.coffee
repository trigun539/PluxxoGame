window.requestAnimFrame = (->
  window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.oRequestAnimationFrame or window.msRequestAnimationFrame or (callback, element) ->
    window.setTimeout callback, 1000 / 60
)()

# Classes
class Pluxxor
  constructor: (@name, @x, @y, @w, @h, @angle, @img, @xImgPos, @yImgPos) ->

canvas = undefined
ctx = undefined
canvasW = 710
canvasH = 520
map = undefined
mapCtx =  undefined
mapX = 0
mapY = 0
mapW = canvasW * 2
mapH = canvasH * 2
rightKey = false
leftKey = false
upKey = false
downKey = false
angle = undefined
adjacent = 0
opposite = 0
mouseX = undefined
mouseY = undefined
pluxxorImg1 = new Image()
playerX = (canvasW/2)-2.5
playerY = (canvasH/2)-2.5
pluxxor = undefined
pluxxorCounter = 0

init = ->
  map = document.createElement("canvas")
  mapCtx = map.getContext("2d")
  map.width = mapW
  map.height = mapH
  canvas = document.getElementById("canvas")
  ctx = canvas.getContext("2d")
  document.addEventListener "keydown", keyDown, false
  document.addEventListener "keyup", keyUp, false
  canvas.addEventListener "mouseover", mouseOnCanvas, false
  canvas.addEventListener "mouseout", mouseOffCanvas, false
  pluxxorImg1.src = "img/pluxxo1.png"
  pluxxorImg1.onload = animate()
  return

keyDown = (e) ->
  if e.keyCode is 87
    upKey = true
  else if e.keyCode is 83
    downKey = true
  else if e.keyCode is 68
    rightKey = true
  else leftKey = true  if e.keyCode is 65
  
  return
  
keyUp = (e) ->
  if e.keyCode is 87
    upKey = false
  else if e.keyCode is 83
    downKey = false
  else if e.keyCode is 68
    rightKey = false
  else leftKey = false  if e.keyCode is 65
  
  return

mouseOnCanvas = (e) ->
  shooting = false;
  canvas.addEventListener "mousemove", aim, false
  return
  
mouseOffCanvas = (e) ->
  canvas.removeEventListener "mousemove", aim, false
  mouseX = undefined
  mouseY = undefined
  angle = undefined
  return

aim = (e) ->
  mouseX = (e.x - this.offsetLeft) 
  mouseY = (e.y - this.offsetTop) 
  return

animate = ->
  requestAnimFrame animate
  clearCanvas()
  drawBackground()
  drawMap()
  drawPlayer()
  copyMapToCanvas()
  return

clearCanvas = ->
  mapCtx.clearRect 0, 0, mapCtx.canvas.width, mapCtx.canvas.height
  return

drawBackground = ->
  mapCtx.fillStyle = "rgba(0, 0, 0, 1)"
  mapCtx.fillRect 0, 0, mapCtx.canvas.width, mapCtx.canvas.height
  return

drawMap = ->
  # GRID LINES
  mapCtx.shadowOffsetX = 0
  mapCtx.shadowOffsetY = 0
  
  # Outside Box
  
  mapCtx.beginPath();
  mapCtx.rect(0, 0, mapW, mapH);
  mapCtx.lineWidth = 10;
  mapCtx.strokeStyle = '#8ED6FF';
  mapCtx.stroke();
  
  # Horizontal Lines  
  i = 1
  while i < 20
    mapCtx.fillStyle = "rgba(144, 144, 144, .2)"
    mapCtx.fillRect 0, 52 * i, mapW, 1
    i++
  
  # Vertical Lines
  i = 1
  while i < 20
    mapCtx.fillStyle = "rgba(144, 144, 144, .2)"
    mapCtx.fillRect 71 * i, 0, 1, mapH
    i++
  
  #Shadow Effect
  
  mapCtx.shadowColor = "#FFFFFF"
  mapCtx.shadowBlur = 5
  mapCtx.shadowOffsetX = 2
  mapCtx.shadowOffsetY = 2
  
  # Walls
  
  # Style
  mapCtx.shadowColor = "rgba(100, 200, 248, 1)"
  mapCtx.shadowBlur = 5
  mapCtx.shadowOffsetX = 0
  mapCtx.shadowOffsetY = 0
  mapCtx.strokeStyle = "rgba(100, 200, 248, 1)"
  mapCtx.lineWidth = 1
  
  # Position
  mapCtx.strokeRect 71, 52, 200, 5
  mapCtx.strokeRect 440, 52, 200, 5
  mapCtx.strokeRect 71, 468, 200, 5
  mapCtx.strokeRect 440, 468, 200, 5
  mapCtx.strokeRect 352.5, 60, 5, 100
  mapCtx.strokeRect 352.5, 340, 5, 100
  mapCtx.beginPath()
  mapCtx.moveTo 100, 250
  mapCtx.lineTo 150, 250
  mapCtx.lineTo 150, 150
  mapCtx.lineTo 155, 150
  mapCtx.lineTo 155, 250
  mapCtx.lineTo 205, 250
  mapCtx.lineTo 205, 255
  mapCtx.lineTo 155, 255
  mapCtx.lineTo 155, 355
  mapCtx.lineTo 150, 355
  mapCtx.lineTo 150, 255
  mapCtx.lineTo 100, 255
  mapCtx.closePath()
  mapCtx.stroke()
  mapCtx.beginPath()
  mapCtx.moveTo 500, 250
  mapCtx.lineTo 550, 250
  mapCtx.lineTo 550, 150
  mapCtx.lineTo 555, 150
  mapCtx.lineTo 555, 250
  mapCtx.lineTo 605, 250
  mapCtx.lineTo 605, 255
  mapCtx.lineTo 555, 255
  mapCtx.lineTo 555, 355
  mapCtx.lineTo 550, 355
  mapCtx.lineTo 550, 255
  mapCtx.lineTo 500, 255
  mapCtx.closePath()
  mapCtx.stroke()
  
  # Reset Style
  mapCtx.shadowColor = "rgba(0, 0, 0, 0)"
  mapCtx.shadowBlur = 0
  mapCtx.shadowOffsetX = 0
  mapCtx.shadowOffsetY = 0
  
  return

# Setting up player(s)
pluxxor = new Pluxxor("David", ((canvasW/2)-2.5), ((canvasH/2)-2.5), 27, 42, 0, pluxxorImg1, 0, 0)

drawPlayer = () ->
  # Player Movement
  if rightKey
    pluxxor.x += 5
  else
    if leftKey
      pluxxor.x -= 5
  if upKey
    pluxxor.y -= 5
  else
    if downKey
      pluxxor.y += 5

  # Player Movement Restrictions
  if pluxxor.x <= 7.5
    pluxxor.x = 7.5

  if pluxxor.x >= (mapW-12.5)
    pluxxor.x = (mapW-12.5)
    
  if pluxxor.y <= 7.5    
    pluxxor.y = 7.5
      
  if pluxxor.y >= (mapH-12.5)
    pluxxor.y = (mapH-12.5)
  
  # Adding Player Sprite
  if pluxxorCounter >= 0 and pluxxorCounter < 10
    pluxxor.xImgPos = pluxxor.width * 0
  else if pluxxorCounter >= 10 and pluxxorCounter < 20
    pluxxor.xImgPos = pluxxor.width * 1
  else if pluxxorCounter >= 20 and pluxxorCounter < 30
    pluxxor.xImgPos = pluxxor.width * 2
  else if pluxxorCounter >= 30 and pluxxorCounter < 40    
    pluxxor.xImgPos = pluxxor.width * 3
  else
    if pluxxorCounter is 40
      pluxxorCounter = 0
      pluxxor.xImgPos = pluxxor.width * 3
  
  drawSprite(pluxxor)
  pluxxorCounter++
  return  
  
drawSprite = (pluxxor) ->
  mapCtx.drawImage pluxxor.img, 0, 0, 27, 42, pluxxor.x, pluxxor.y, 27, 42
  return

copyMapToCanvas = ->
  
  # Canvas Movement
  mapX = pluxxor.x - ((canvasW/2)-2.5)
  mapY = pluxxor.y - ((canvasH/2)-2.5)
  
  if pluxxor.x <= (canvasW/2)
    mapX = 0
  
  if pluxxor.y <= (canvasH/2)
    mapY = 0
  
  if pluxxor.x >= mapW - (canvasW/2)
    mapX = mapW - canvasW
    
  if pluxxor.y >= mapH - (canvasH/2)
    mapY = mapH - canvasH
    
  ctx.drawImage(map, mapX, mapY, canvasW, canvasH, 0, 0, canvasW, canvasH)
  return

init()