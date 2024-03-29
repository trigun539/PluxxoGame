window.requestAnimFrame = (->
  window.requestAnimationFrame or window.webkitRequestAnimationFrame or window.mozRequestAnimationFrame or window.oRequestAnimationFrame or window.msRequestAnimationFrame or (callback, element) ->
    window.setTimeout callback, 1000 / 60
)()

# Classes
class Pluxxor
  constructor: (@name, @x, @y, @w, @h, @angle, @img) ->

canvas = undefined
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
bulletSpeed = 5
pluxxorImg1 = new Image()
shooting = false
pluxxorCounter = 0
pluxxorArray = new Array()
bullets = [
  [1, 0, 0, 0]
  [1, 0, 0, 0]
  [1, 0, 0, 0]
  [1, 0, 0, 0]
  [1, 0, 0, 0]
  [1, 0, 0, 0]
  [1, 0, 0, 0]
  [1, 0, 0, 0]
  [1, 0, 0, 0]
  [1, 0, 0, 0]
  [1, 0, 0, 0]
  [1, 0, 0, 0]
  [1, 0, 0, 0]
  [1, 0, 0, 0]
  [1, 0, 0, 0]
  [1, 0, 0, 0]
  [1, 0, 0, 0]
  [1, 0, 0, 0]
  [1, 0, 0, 0]
  [1, 0, 0, 0]
  [1, 0, 0, 0]
]

init = ->
  canvas = document.getElementById("canvas")
  context = canvas.getContext("2d")
  document.addEventListener "keydown", keyDown, false
  document.addEventListener "keyup", keyUp, false
  canvas.addEventListener "mouseover", mouseOnCanvas, false
  canvas.addEventListener "mouseout", mouseOffCanvas, false
  # Load soldier images for loop
  pluxxorImg1.src = "img/pluxxo1.png"
  pluxxorImg1.onload = loadPluxxors()
  
  console.log "init happening.."
  
  return

animate = ->
  requestAnimFrame animate
  clearCanvas()
  drawBackground()
  drawMap()
  drawPluxxors()
  #reload()
  #moveBullets()
  #drawBullets()
  console.log "Animate function"
  return

clearCanvas = ->
  context.clearRect 0, 0, context.canvas.width, context.canvas.height
  console.log "clearing canvas"
  return

drawBackground = ->
  context.fillStyle = "rgba(0, 0, 0, 1)"
  context.fillRect 0,0,context.canvas.width,context.canvas.height
  console.log "drawing background"
  return

drawMap = ->
  # GRID LINES
  
  context.shadowOffsetX = 0
  context.shadowOffsetY = 0
  
  # Horizontal Lines  
  i = 1
  while i < 10
    context.fillStyle = "rgba(144, 144, 144, .2)"
    context.fillRect 0, 52 * i, 710, 1
    i++
  
  # Vertical Lines
  i = 1
  while i < 10
    context.fillStyle = "rgba(144, 144, 144, .2)"
    context.fillRect 71 * i, 0, 1, 520
    i++
  
  #Shadow Effect
  
  context.shadowColor = "#FFFFFF"
  context.shadowBlur = 5
  context.shadowOffsetX = 2
  context.shadowOffsetY = 2
  
  # Walls
  
  # Style
  context.shadowColor = "rgba(100, 200, 248, 1)"
  context.shadowBlur = 5
  context.shadowOffsetX = 0
  context.shadowOffsetY = 0
  context.strokeStyle = "rgba(100, 200, 248, 1)"
  context.lineWidth = 1
  
  # Position
  context.strokeRect 71, 52, 200, 5
  context.strokeRect 440, 52, 200, 5
  context.strokeRect 71, 468, 200, 5
  context.strokeRect 440, 468, 200, 5
  context.strokeRect 352.5, 60, 5, 100
  context.strokeRect 352.5, 340, 5, 100
  context.beginPath()
  context.moveTo 100, 250
  context.lineTo 150, 250
  context.lineTo 150, 150
  context.lineTo 155, 150
  context.lineTo 155, 250
  context.lineTo 205, 250
  context.lineTo 205, 255
  context.lineTo 155, 255
  context.lineTo 155, 355
  context.lineTo 150, 355
  context.lineTo 150, 255
  context.lineTo 100, 255
  context.closePath()
  context.stroke()
  context.beginPath()
  context.moveTo 500, 250
  context.lineTo 550, 250
  context.lineTo 550, 150
  context.lineTo 555, 150
  context.lineTo 555, 250
  context.lineTo 605, 250
  context.lineTo 605, 255
  context.lineTo 555, 255
  context.lineTo 555, 355
  context.lineTo 550, 355
  context.lineTo 550, 255
  context.lineTo 500, 255
  context.closePath()
  context.stroke()
  
  # Reset Style
  context.shadowColor = "rgba(0, 0, 0, 0)"
  context.shadowBlur = 0
  context.shadowOffsetX = 0
  context.shadowOffsetY = 0
  
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
  canvas.addEventListener "click", shooting, false
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
  
shooting = (e) ->
  shooting = true
  return

reload = ->
  i = 0
  while i < bullets.length
    if bullets[i][2] < 0 or bullets[i][2] > context.canvas.width or bullets[i][3] < 0 or bullets[i][3] > context.canvas.height
      bullets[i][0] = 1    
      bullets[i][1] = 0    
      bullets[i][2] = 0    
      bullets[i][3] = 0    
    
    i++
  
  return
  
loadPluxxors = () ->
  pluxxor = new Pluxxor("David", 100, 100, 28, 48, pluxxorImg1)
  pluxxorArray.push(pluxxor)
  return

drawPluxxors = () ->
  console.log "Was here"
  console.log pluxxorArray
  return  
  
drawSprite = (pluxxor) ->
  if shooting
    context.save()
    context.translate pluxxor.x, pluxxor.y
    context.rotate pluxxor.angle
    context.clearRect -pluxxor.w/2, -pluxxor.h/2, pluxxor.w, pluxxor.h
    context.drawImage pluxxor.img, (pluxxor.imgX + 112), pluxxor.imgY, pluxxor.w, pluxxor.h, -pluxxor.w/2, -pluxxor.h/2, pluxxor.w, pluxxor.h
    context.restore()  
  else 
    context.save()
    context.translate pluxxor.x, pluxxor.y
    context.rotate pluxxor.angle
    context.clearRect -pluxxor.w/2, -pluxxor.h/2, pluxxor.w, pluxxor.h
    context.drawImage pluxxor.img, pluxxor.imgX, pluxxor.imgY, pluxxor.w, pluxxor.h, -pluxxor.w/2, -pluxxor.h/2, pluxxor.w, pluxxor.h
    context.restore()

  return

shoot = ->
  i = 0
  while i < bullets.length
    if bullets[i][0] is 1
      bullets[i][0] = 0
      bullets[i][1] = (angle - (Math.PI/2))
      bullets[i][2] = pluxxor.x
      bullets[i][3] = pluxxor.y
      break
    else
      i++ 
  return

moveBullets = ->
  i = 0
  while i < bullets.length
    if bullets[i][0] is 0
      if bullets[i][1] is 0
        bullets[i][2] += bulletSpeed          
      else if 0 < bullets[i][1] < (Math.PI/2)                   # 1st Quadrant
        bullets[i][2] += bulletSpeed*(Math.cos(bullets[i][1]))
        bullets[i][3] += bulletSpeed*(Math.sin(bullets[i][1]))
      else if bullets[i][1] is (Math.PI/2)
        bullets[i][3] += bulletSpeed
      else if (Math.PI/2) < bullets[i][1] < Math.PI             # 2nd Quadrant
        bullets[i][2] -= bulletSpeed*(Math.sin(bullets[i][1] - (Math.PI/2)))
        bullets[i][3] += bulletSpeed*(Math.cos(bullets[i][1] - (Math.PI/2)))
      else if bullets[i][1] is Math.PI
        bullets[i][2] -= bulletSpeed
      else if Math.PI < bullets[i][1] < (3*Math.PI/2)           # 3rd Quadrant
        bullets[i][2] -= bulletSpeed*(Math.cos(bullets[i][1] - Math.PI))
        bullets[i][3] -= bulletSpeed*(Math.sin(bullets[i][1] - Math.PI))
      else if bullets[i][1] is (3*Math.PI/2)
        bullets[i][3] -= bulletSpeed
      else if (3*Math.PI/2) < bullets[i][1] < (2*Math.PI)       # 4th Quadrant
        bullets[i][2] += bulletSpeed*(Math.sin(bullets[i][1] - (3*Math.PI/2)))
        bullets[i][3] -= bulletSpeed*(Math.cos(bullets[i][1] - (3*Math.PI/2)))
      
    i++
    
  return

drawBullets = ->
  i = 0
  while i < bullets.length
    if bullets[i][0] is 0
      if bullets[i][1] is 0
        context.strokeStyle = "rgba(150, 255, 0, .8)"
        context.fillStyle = "rgba(150, 255, 0, .8)"
        context.fillRect bullets[i][2]-1, bullets[i][3]-1, 2, 2    
      else if 0 < bullets[i][1] < (Math.PI/2)                   # 1st Quadrant
        context.save()
        context.translate bullets[i][2], bullets[i][3]
        context.rotate bullets[i][1]
        context.strokeStyle = "rgba(150, 255, 0, .8)"
        context.fillStyle = "rgba(150, 255, 0, .8)"
        context.fillRect -1, -1, 2, 2
        context.restore()
      else if bullets[i][1] is (Math.PI/2)
        context.strokeStyle = "rgba(150, 255, 0, .8)"
        context.fillStyle = "rgba(150, 255, 0, .8)"
        context.fillRect bullets[i][2]-1, bullets[i][3]-1, 2, 2
      else if (Math.PI/2) < bullets[i][1] < Math.PI             # 2nd Quadrant
        context.save()
        context.translate bullets[i][2], bullets[i][3]
        context.rotate bullets[i][1]
        context.strokeStyle = "rgba(150, 255, 0, .8)"
        context.fillStyle = "rgba(150, 255, 0, .8)"
        context.fillRect -1, -1, 2, 2
        context.restore()
      else if bullets[i][1] is Math.PI
        context.strokeStyle = "rgba(150, 255, 0, .8)"
        context.fillStyle = "rgba(150, 255, 0, .8)"
        context.fillRect bullets[i][2]-1, bullets[i][3]-1, 2, 2
      else if Math.PI < bullets[i][1] < (3*Math.PI/2)           # 3rd Quadrant
        context.save()
        context.translate bullets[i][2], bullets[i][3]
        context.rotate bullets[i][1]
        context.strokeStyle = "rgba(150, 255, 0, .8)"
        context.fillStyle = "rgba(150, 255, 0, .8)"
        context.fillRect -1, -1, 2, 2
        context.restore()
      else if bullets[i][1] is (3*Math.PI/2)
        context.strokeStyle = "rgba(150, 255, 0, .8)"
        context.fillStyle = "rgba(150, 255, 0, .8)"
        context.fillRect bullets[i][2]-1, bullets[i][3]-1, 2, 2
      else if (3*Math.PI/2) < bullets[i][1] < (2*Math.PI)       # 4th Quadrant
        context.save()
        context.translate bullets[i][2], bullets[i][3]
        context.rotate bullets[i][1]
        context.strokeStyle = "rgba(150, 255, 0, .8)"
        context.fillStyle = "rgba(150, 255, 0, .8)"
        context.fillRect -1, -1, 2, 2
        context.restore()
    i++
  return

init()