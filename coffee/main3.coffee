window.requestAnimFrame = (->
  window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.oRequestAnimationFrame or window.msRequestAnimationFrame or (callback, element) ->
    window.setTimeout callback, 1000 / 60
)()

# Classes
class Pluxxor
  constructor: (@name, @xPos, @yPos, @width, @height, @img, @xImgPos, @yImgPos) ->

canvas = undefined
canvasWidth = 500
canvasHeight = 400
context = undefined
rightKey = false
leftKey = false
upKey = false
downKey = false
width = 500
height = 400
fired = false
angle = undefined
adjacent = 0
opposite = 0
mouseX = undefined
mouseY = undefined
pluxxorImg1 = new Image() 
pluxxorXImgPos = 0 
pluxxorYImgPos = 0
pluxxorCounter = 0

init = ->
  canvas = document.getElementById("canvas")
  context = canvas.getContext("2d")
  document.addEventListener "keydown", keyDown, false
  document.addEventListener "keyup", keyUp, false
  canvas.addEventListener "mouseover", mouseOnCanvas, false
  canvas.addEventListener "mouseout", mouseOffCanvas, false
  pluxxorImg1.src = "img/pluxxoSprite.png"
  pluxxorImg1.onload = animate
  return

animate = ->
  requestAnimFrame animate
  drawPluxxor()
  return
  
keyDown = (e) ->
  if e.keyCode is 87
    upKey = true
  else if e.keyCode is 83
    downKey = true
  else if e.keyCode is 68
    rightKey = true
  else leftKey = true  if e.keyCode is 65
  
keyUp = (e) ->
  if e.keyCode is 87
    upKey = false
  else if e.keyCode is 83
    downKey = false
  else if e.keyCode is 68
    rightKey = false
  else leftKey = false  if e.keyCode is 65

mouseOnCanvas = (e) ->
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

pluxxor = new Pluxxor("David", 100, 100, 25, 30, pluxxorImg1, 50, 50)

drawPluxxor = ->
  if mouseX and mouseY
    if mouseX > pluxxor.xPos and mouseY < pluxxor.yPos           # 4th quadrant
      adjacent = pluxxor.yPos - mouseY
      opposite = mouseX - pluxxor.xPos
      angle = (Math.atan(opposite/adjacent) + ((3*Math.PI)/2))
    else if mouseX < pluxxor.xPos and mouseY < pluxxor.yPos      # 3rd quadrant
        adjacent = pluxxor.xPos - mouseX
        opposite = pluxxor.yPos - mouseY
        angle = (Math.atan(opposite/adjacent) + Math.PI)
    else if mouseX < pluxxor.xPos and mouseY > pluxxor.yPos      # 2nd quadrant
        adjacent = mouseY - pluxxor.yPos
        opposite = pluxxor.xPos - mouseX
        angle = (Math.atan(opposite/adjacent) + (Math.PI/2) )
    else if mouseX > pluxxor.xPos and mouseY > pluxxor.yPos      # 1st quadrant
        adjacent = mouseX - pluxxor.xPos
        opposite = mouseY - pluxxor.yPos
        angle = Math.atan(opposite/adjacent)
    else if mouseX is pluxxor.xPos and pluxxor.yPos > mouseY
        angle = ((3*Math.PI)/2)
    else if mouseX is pluxxor.xPos and pluxxor.yPos < mouseY
        angle = (Math.PI/2)
    else if mouseX < pluxxor.xPos and pluxxor.yPos is mouseY
        angle = Math.PI
    else if mouseX > pluxxor.xPos and pluxxor.yPos is mouseY
        angle = 0
  
  # X Y MOVEMENT
  
  if rightKey
    pluxxor.xPos += 5
  else
    if leftKey
      pluxxor.xPos -= 5
  if upKey
    pluxxor.yPos -= 5
  else
    if downKey
      pluxxor.yPos += 5
  
  pluxxor.xPos = 0  if pluxxor.xPos <= 0
  pluxxor.xPos = width - pluxxor.width  if (pluxxor.xPos + pluxxor.width) >= width
  pluxxor.yPos = 0  if pluxxor.yPos <= 0
  pluxxor.yPos = height - pluxxor.height  if (pluxxor.yPos + pluxxor.height) >= height
  
  if pluxxorCounter >= 0 and pluxxorCounter < 10
    drawSprite pluxxor.img, pluxxor.width * 0, 0, pluxxor.width, pluxxor.height, pluxxor.xPos, pluxxor.yPos, angle
  else if pluxxorCounter >= 10 and pluxxorCounter < 20
    drawSprite pluxxor.img, pluxxor.width * 1, 0, pluxxor.width, pluxxor.height, pluxxor.xPos, pluxxor.yPos, angle 
  else if pluxxorCounter >= 20 and pluxxorCounter < 30
    drawSprite pluxxor.img, pluxxor.width * 2, 0, pluxxor.width, pluxxor.height, pluxxor.xPos, pluxxor.yPos, angle 
  else if pluxxorCounter >= 30 and pluxxorCounter < 40    
    drawSprite pluxxor.img, pluxxor.width * 3, 0, pluxxor.width, pluxxor.height, pluxxor.xPos, pluxxor.yPos, angle
  else
  if pluxxorCounter is 40
    pluxxorCounter = 0
    drawSprite pluxxor.img, pluxxor.width * 3, 0, pluxxor.width, pluxxor.height, pluxxor.xPos, pluxxor.yPos, angle
  
  pluxxorCounter++
  return  
  
drawSprite = (sprite, imgX, imgY, w, h, x, y, angle) ->
  if rightKey
      context.clearRect x-5, y, w, h
    else
      if leftKey
        context.clearRect x+5, y, w, h
    if upKey
      context.clearRect x, y+5, w, h
    else
      if downKey
        context.clearRect x, y-5, w, h
    
  context.clearRect 0, 0, w, h if not rightKey or not leftKey or not upKey or not downKey

  if angle
    context.save()
    context.translate x, y
    context.rotate angle
    context.clearRect -w/2, -h/2, w, h
    context.drawImage sprite, imgX, imgY, w, h, -w/2, -h/2, w, h
    context.restore()
  else
    context.drawImage sprite, imgX, imgY, w, h, x, y, w, h
  
  console.log (angle*(180/Math.PI))
  return
  
init()