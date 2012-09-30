// Generated by CoffeeScript 1.3.3
(function() {
  var Pluxxor, adjacent, aim, angle, animate, bulletSpeed, bullets, canvas, clearCanvas, context, downKey, drawBackground, drawBullets, drawMap, drawPluxxors, drawSprite, fired, height, init, keyDown, keyUp, leftKey, loadPluxxors, mouseOffCanvas, mouseOnCanvas, mouseX, mouseY, moveBullets, opposite, pluxxorArray, pluxxorCounter, pluxxorImg1, reload, rightKey, shoot, shooting, upKey, width;

  window.requestAnimFrame = (function() {
    return window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || function(callback, element) {
      return window.setTimeout(callback, 1000 / 60);
    };
  })();

  Pluxxor = (function() {

    function Pluxxor(name, x, y, w, h, angle, img) {
      this.name = name;
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
      this.angle = angle;
      this.img = img;
    }

    return Pluxxor;

  })();

  canvas = void 0;

  context = void 0;

  rightKey = false;

  leftKey = false;

  upKey = false;

  downKey = false;

  width = 500;

  height = 400;

  fired = false;

  angle = void 0;

  adjacent = 0;

  opposite = 0;

  mouseX = void 0;

  mouseY = void 0;

  bulletSpeed = 5;

  pluxxorImg1 = new Image();

  shooting = false;

  pluxxorCounter = 0;

  pluxxorArray = new Array();

  bullets = [[1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0], [1, 0, 0, 0]];

  init = function() {
    canvas = document.getElementById("canvas");
    context = canvas.getContext("2d");
    document.addEventListener("keydown", keyDown, false);
    document.addEventListener("keyup", keyUp, false);
    canvas.addEventListener("mouseover", mouseOnCanvas, false);
    canvas.addEventListener("mouseout", mouseOffCanvas, false);
    pluxxorImg1.src = "img/pluxxo1.png";
    pluxxorImg1.onload = loadPluxxors();
    console.log("init happening..");
  };

  animate = function() {
    requestAnimFrame(animate);
    clearCanvas();
    drawBackground();
    drawMap();
    drawPluxxors();
    console.log("Animate function");
  };

  clearCanvas = function() {
    context.clearRect(0, 0, context.canvas.width, context.canvas.height);
    console.log("clearing canvas");
  };

  drawBackground = function() {
    context.fillStyle = "rgba(0, 0, 0, 1)";
    context.fillRect(0, 0, context.canvas.width, context.canvas.height);
    console.log("drawing background");
  };

  drawMap = function() {
    var i;
    context.shadowOffsetX = 0;
    context.shadowOffsetY = 0;
    i = 1;
    while (i < 10) {
      context.fillStyle = "rgba(144, 144, 144, .2)";
      context.fillRect(0, 52 * i, 710, 1);
      i++;
    }
    i = 1;
    while (i < 10) {
      context.fillStyle = "rgba(144, 144, 144, .2)";
      context.fillRect(71 * i, 0, 1, 520);
      i++;
    }
    context.shadowColor = "#FFFFFF";
    context.shadowBlur = 5;
    context.shadowOffsetX = 2;
    context.shadowOffsetY = 2;
    context.shadowColor = "rgba(100, 200, 248, 1)";
    context.shadowBlur = 5;
    context.shadowOffsetX = 0;
    context.shadowOffsetY = 0;
    context.strokeStyle = "rgba(100, 200, 248, 1)";
    context.lineWidth = 1;
    context.strokeRect(71, 52, 200, 5);
    context.strokeRect(440, 52, 200, 5);
    context.strokeRect(71, 468, 200, 5);
    context.strokeRect(440, 468, 200, 5);
    context.strokeRect(352.5, 60, 5, 100);
    context.strokeRect(352.5, 340, 5, 100);
    context.beginPath();
    context.moveTo(100, 250);
    context.lineTo(150, 250);
    context.lineTo(150, 150);
    context.lineTo(155, 150);
    context.lineTo(155, 250);
    context.lineTo(205, 250);
    context.lineTo(205, 255);
    context.lineTo(155, 255);
    context.lineTo(155, 355);
    context.lineTo(150, 355);
    context.lineTo(150, 255);
    context.lineTo(100, 255);
    context.closePath();
    context.stroke();
    context.beginPath();
    context.moveTo(500, 250);
    context.lineTo(550, 250);
    context.lineTo(550, 150);
    context.lineTo(555, 150);
    context.lineTo(555, 250);
    context.lineTo(605, 250);
    context.lineTo(605, 255);
    context.lineTo(555, 255);
    context.lineTo(555, 355);
    context.lineTo(550, 355);
    context.lineTo(550, 255);
    context.lineTo(500, 255);
    context.closePath();
    context.stroke();
    context.shadowColor = "rgba(0, 0, 0, 0)";
    context.shadowBlur = 0;
    context.shadowOffsetX = 0;
    context.shadowOffsetY = 0;
  };

  keyDown = function(e) {
    if (e.keyCode === 87) {
      upKey = true;
    } else if (e.keyCode === 83) {
      downKey = true;
    } else if (e.keyCode === 68) {
      rightKey = true;
    } else {
      if (e.keyCode === 65) {
        leftKey = true;
      }
    }
  };

  keyUp = function(e) {
    if (e.keyCode === 87) {
      upKey = false;
    } else if (e.keyCode === 83) {
      downKey = false;
    } else if (e.keyCode === 68) {
      rightKey = false;
    } else {
      if (e.keyCode === 65) {
        leftKey = false;
      }
    }
  };

  mouseOnCanvas = function(e) {
    shooting = false;
    canvas.addEventListener("mousemove", aim, false);
    canvas.addEventListener("click", shooting, false);
  };

  mouseOffCanvas = function(e) {
    canvas.removeEventListener("mousemove", aim, false);
    mouseX = void 0;
    mouseY = void 0;
    angle = void 0;
  };

  aim = function(e) {
    mouseX = e.x - this.offsetLeft;
    mouseY = e.y - this.offsetTop;
  };

  shooting = function(e) {
    shooting = true;
  };

  reload = function() {
    var i;
    i = 0;
    while (i < bullets.length) {
      if (bullets[i][2] < 0 || bullets[i][2] > context.canvas.width || bullets[i][3] < 0 || bullets[i][3] > context.canvas.height) {
        bullets[i][0] = 1;
        bullets[i][1] = 0;
        bullets[i][2] = 0;
        bullets[i][3] = 0;
      }
      i++;
    }
  };

  loadPluxxors = function() {
    var pluxxor;
    pluxxor = new Pluxxor("David", 100, 100, 28, 48, pluxxorImg1);
    pluxxorArray.push(pluxxor);
  };

  drawPluxxors = function() {
    console.log("Was here");
    console.log(pluxxorArray);
  };

  drawSprite = function(pluxxor) {
    if (shooting) {
      context.save();
      context.translate(pluxxor.x, pluxxor.y);
      context.rotate(pluxxor.angle);
      context.clearRect(-pluxxor.w / 2, -pluxxor.h / 2, pluxxor.w, pluxxor.h);
      context.drawImage(pluxxor.img, pluxxor.imgX + 112, pluxxor.imgY, pluxxor.w, pluxxor.h, -pluxxor.w / 2, -pluxxor.h / 2, pluxxor.w, pluxxor.h);
      context.restore();
    } else {
      context.save();
      context.translate(pluxxor.x, pluxxor.y);
      context.rotate(pluxxor.angle);
      context.clearRect(-pluxxor.w / 2, -pluxxor.h / 2, pluxxor.w, pluxxor.h);
      context.drawImage(pluxxor.img, pluxxor.imgX, pluxxor.imgY, pluxxor.w, pluxxor.h, -pluxxor.w / 2, -pluxxor.h / 2, pluxxor.w, pluxxor.h);
      context.restore();
    }
  };

  shoot = function() {
    var i;
    i = 0;
    while (i < bullets.length) {
      if (bullets[i][0] === 1) {
        bullets[i][0] = 0;
        bullets[i][1] = angle - (Math.PI / 2);
        bullets[i][2] = pluxxor.x;
        bullets[i][3] = pluxxor.y;
        break;
      } else {
        i++;
      }
    }
  };

  moveBullets = function() {
    var i, _ref, _ref1, _ref2, _ref3;
    i = 0;
    while (i < bullets.length) {
      if (bullets[i][0] === 0) {
        if (bullets[i][1] === 0) {
          bullets[i][2] += bulletSpeed;
        } else if ((0 < (_ref = bullets[i][1]) && _ref < (Math.PI / 2))) {
          bullets[i][2] += bulletSpeed * (Math.cos(bullets[i][1]));
          bullets[i][3] += bulletSpeed * (Math.sin(bullets[i][1]));
        } else if (bullets[i][1] === (Math.PI / 2)) {
          bullets[i][3] += bulletSpeed;
        } else if (((Math.PI / 2) < (_ref1 = bullets[i][1]) && _ref1 < Math.PI)) {
          bullets[i][2] -= bulletSpeed * (Math.sin(bullets[i][1] - (Math.PI / 2)));
          bullets[i][3] += bulletSpeed * (Math.cos(bullets[i][1] - (Math.PI / 2)));
        } else if (bullets[i][1] === Math.PI) {
          bullets[i][2] -= bulletSpeed;
        } else if ((Math.PI < (_ref2 = bullets[i][1]) && _ref2 < (3 * Math.PI / 2))) {
          bullets[i][2] -= bulletSpeed * (Math.cos(bullets[i][1] - Math.PI));
          bullets[i][3] -= bulletSpeed * (Math.sin(bullets[i][1] - Math.PI));
        } else if (bullets[i][1] === (3 * Math.PI / 2)) {
          bullets[i][3] -= bulletSpeed;
        } else if (((3 * Math.PI / 2) < (_ref3 = bullets[i][1]) && _ref3 < (2 * Math.PI))) {
          bullets[i][2] += bulletSpeed * (Math.sin(bullets[i][1] - (3 * Math.PI / 2)));
          bullets[i][3] -= bulletSpeed * (Math.cos(bullets[i][1] - (3 * Math.PI / 2)));
        }
      }
      i++;
    }
  };

  drawBullets = function() {
    var i, _ref, _ref1, _ref2, _ref3;
    i = 0;
    while (i < bullets.length) {
      if (bullets[i][0] === 0) {
        if (bullets[i][1] === 0) {
          context.strokeStyle = "rgba(150, 255, 0, .8)";
          context.fillStyle = "rgba(150, 255, 0, .8)";
          context.fillRect(bullets[i][2] - 1, bullets[i][3] - 1, 2, 2);
        } else if ((0 < (_ref = bullets[i][1]) && _ref < (Math.PI / 2))) {
          context.save();
          context.translate(bullets[i][2], bullets[i][3]);
          context.rotate(bullets[i][1]);
          context.strokeStyle = "rgba(150, 255, 0, .8)";
          context.fillStyle = "rgba(150, 255, 0, .8)";
          context.fillRect(-1, -1, 2, 2);
          context.restore();
        } else if (bullets[i][1] === (Math.PI / 2)) {
          context.strokeStyle = "rgba(150, 255, 0, .8)";
          context.fillStyle = "rgba(150, 255, 0, .8)";
          context.fillRect(bullets[i][2] - 1, bullets[i][3] - 1, 2, 2);
        } else if (((Math.PI / 2) < (_ref1 = bullets[i][1]) && _ref1 < Math.PI)) {
          context.save();
          context.translate(bullets[i][2], bullets[i][3]);
          context.rotate(bullets[i][1]);
          context.strokeStyle = "rgba(150, 255, 0, .8)";
          context.fillStyle = "rgba(150, 255, 0, .8)";
          context.fillRect(-1, -1, 2, 2);
          context.restore();
        } else if (bullets[i][1] === Math.PI) {
          context.strokeStyle = "rgba(150, 255, 0, .8)";
          context.fillStyle = "rgba(150, 255, 0, .8)";
          context.fillRect(bullets[i][2] - 1, bullets[i][3] - 1, 2, 2);
        } else if ((Math.PI < (_ref2 = bullets[i][1]) && _ref2 < (3 * Math.PI / 2))) {
          context.save();
          context.translate(bullets[i][2], bullets[i][3]);
          context.rotate(bullets[i][1]);
          context.strokeStyle = "rgba(150, 255, 0, .8)";
          context.fillStyle = "rgba(150, 255, 0, .8)";
          context.fillRect(-1, -1, 2, 2);
          context.restore();
        } else if (bullets[i][1] === (3 * Math.PI / 2)) {
          context.strokeStyle = "rgba(150, 255, 0, .8)";
          context.fillStyle = "rgba(150, 255, 0, .8)";
          context.fillRect(bullets[i][2] - 1, bullets[i][3] - 1, 2, 2);
        } else if (((3 * Math.PI / 2) < (_ref3 = bullets[i][1]) && _ref3 < (2 * Math.PI))) {
          context.save();
          context.translate(bullets[i][2], bullets[i][3]);
          context.rotate(bullets[i][1]);
          context.strokeStyle = "rgba(150, 255, 0, .8)";
          context.fillStyle = "rgba(150, 255, 0, .8)";
          context.fillRect(-1, -1, 2, 2);
          context.restore();
        }
      }
      i++;
    }
  };

  init();

}).call(this);
