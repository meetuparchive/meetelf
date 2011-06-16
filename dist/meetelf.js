(function() {
  window.play = function() {
    var X, Y, assign, blockH, blockW, blocks, board, canvas, ctx, grid, group, height, lookup, name, paint, pick, player, score, setupimg, solo, sqrs, stopped, tiles, toDragon, toMeetup, toPoint, turn, turns, width, won, x, xblock, y;
    board = $("#board");
    width = board.width();
    height = board.height();
    blocks = 10;
    blockW = width / blocks;
    blockH = height / blocks;
    score = 0;
    X = 0;
    Y = 9;
    canvas = board[0];
    ctx = canvas.getContext("2d");
    xblock = function(x, y, f) {
      ctx.save();
      ctx.translate(x * blockW, y * blockH);
      f();
      return ctx.restore();
    };
    setupimg = function(name) {
      var img;
      img = new Image();
      img.src = "tiles/" + name + ".png";
      return img;
    };
    solo = {
      img: setupimg("elf"),
      draw: function(x, y) {
        return xblock(x, y, function() {
          return ctx.drawImage(solo.img, 0, 0, blockW, blockH);
        });
      },
      score: function(s) {
        return score += s;
      },
      hit: function(s) {
        return score -= s;
      }
    };
    group = {
      img: setupimg("group"),
      draw: function(x, y) {
        return xblock(x - 1, y, function() {
          return ctx.drawImage(group.img, 0, 0, 3 * blockW, blockH);
        });
      },
      score: function(s) {
        return score += s;
      },
      hit: function(s) {
        return score -= s / 2;
      }
    };
    player = solo;
    won = false;
    tiles = {
      field: {
        chance: function(x, y) {
          if (y > 7) {
            return 5;
          } else if (y > 2) {
            return 3;
          } else {
            return 1;
          }
        },
        enter: function() {
          return player.score(4);
        }
      },
      wood: {
        chance: function(x, y) {
          if (y > 3 && y < 9) {
            return 3;
          } else {
            return 0;
          }
        },
        enter: function() {
          return player.hit(2);
        }
      },
      crops: {
        chance: function(x, y) {
          if (y > 4) {
            return 1;
          } else {
            return 0;
          }
        },
        enter: function() {
          return player.score(10);
        }
      },
      water: {
        chance: function(x, y) {
          if (y > 2 && y < 5) {
            return 10;
          } else {
            return 0;
          }
        },
        enter: function() {
          return player.hit(10);
        }
      },
      mountain: {
        chance: function(x, y) {
          if (y < 2) {
            5;
          }
          if (y < 8) {
            return 1;
          } else {
            return 0;
          }
        },
        enter: function() {
          return player.hit(4);
        }
      },
      volcano: {
        chance: function(x, y) {
          if (y < 2) {
            return 1;
          } else {
            return 0;
          }
        },
        enter: function() {
          return player.hit(20);
        }
      },
      meetup: {
        chance: function(x, y) {
          return 0;
        },
        enter: function() {
          player.score(50);
          player = group;
          return assign(8, 6, tiles.field);
        }
      },
      dragon: {
        chance: function(x, y) {
          return 0;
        },
        enter: function() {
          player.score(100);
          return won = true;
        }
      }
    };
    for (name in tiles) {
      tiles[name].img = setupimg(name);
      tiles[name].name = name;
    }
    pick = function(x, y) {
      var die, i, name, tile, _ref;
      die = [];
      for (name in tiles) {
        tile = tiles[name];
        for (i = 0, _ref = tile.chance(x, y); (0 <= _ref ? i < _ref : i > _ref); (0 <= _ref ? i += 1 : i -= 1)) {
          die.push(tile);
        }
      }
      return die[Math.floor(Math.random() * die.length)];
    };
    grid = (function() {
      var _results;
      _results = [];
      for (y = 0; (0 <= blocks ? y < blocks : y > blocks); (0 <= blocks ? y += 1 : y -= 1)) {
        _results.push((function() {
          var _results;
          _results = [];
          for (x = 0; (0 <= blocks ? x < blocks : x > blocks); (0 <= blocks ? x += 1 : x -= 1)) {
            _results.push([x, y, pick(x, y)]);
          }
          return _results;
        })());
      }
      return _results;
    })();
    assign = function(x, y, tile) {
      return grid[y][x] = [x, y, tile];
    };
    lookup = function(x, y) {
      return grid[y][x][2];
    };
    assign(8, 6, tiles.meetup);
    assign(2, 0, tiles.dragon);
    paint = function() {
      var row, tile, _i, _j, _len, _len2, _ref;
      for (_i = 0, _len = grid.length; _i < _len; _i++) {
        row = grid[_i];
        for (_j = 0, _len2 = row.length; _j < _len2; _j++) {
          _ref = row[_j], x = _ref[0], y = _ref[1], tile = _ref[2];
          xblock(x, y, function() {
            return ctx.drawImage(tile.img, 0, 0, blockW, blockH);
          });
        }
      }
      return player.draw(X, Y);
    };
    sqrs = function(ax, ay, cx, cy) {
      return (ax - cx) * (ax - cx) + (ay - cy) * (ay - cy);
    };
    toPoint = function(x, y, cx, cy) {
      return Math.sqrt(sqrs(x, y, X, Y)) - Math.sqrt(sqrs(x, y, cx, cy));
    };
    toMeetup = function(cx, cy) {
      return toPoint(8, 6, cx, cy);
    };
    toDragon = function(cx, cy) {
      return toPoint(2, 0, cx, cy);
    };
    turns = 0;
    stopped = false;
    turn = function() {
      var ingrid, r, ranked, valid, ways, x, y, _ref, _ref2, _ref3;
      if (stopped) {
        return;
      }
      ways = [];
      for (x = _ref = -1; (_ref <= 1 ? x <= 1 : x >= 1); (_ref <= 1 ? x += 1 : x -= 1)) {
        for (y = _ref2 = -1; (_ref2 <= 1 ? y <= 1 : y >= 1); (_ref2 <= 1 ? y += 1 : y -= 1)) {
          if (x !== 0 || y !== 0) {
            ways.push([X + x, Y + y]);
          }
        }
      }
      ingrid = function(n) {
        return n >= 0 && n < blocks;
      };
      valid = (function() {
        var _i, _len, _ref, _results;
        _results = [];
        for (_i = 0, _len = ways.length; _i < _len; _i++) {
          _ref = ways[_i], x = _ref[0], y = _ref[1];
          if (ingrid(x) && ingrid(y)) {
            _results.push([x, y]);
          }
        }
        return _results;
      })();
      ranked = (function() {
        var _i, _len, _ref, _results;
        _results = [];
        for (_i = 0, _len = valid.length; _i < _len; _i++) {
          _ref = valid[_i], x = _ref[0], y = _ref[1];
          _results.push([x, y, window.rank(lookup(x, y).name, player === solo ? toMeetup(x, y) : toDragon(x, y))]);
        }
        return _results;
      })();
      ranked.sort(function(a, b) {
        return b[2] - a[2];
      });
      _ref3 = ranked[0], x = _ref3[0], y = _ref3[1], r = _ref3[2];
      X = x;
      Y = y;
      lookup(X, Y).enter();
      paint();
      $("#score").text(score * 100);
      turns++;
      if (won || turns > 20) {
        return setTimeout(function() {
          var message;
          ctx.fillStyle = "black";
          ctx.fillRect(0, 0, width, height);
          ctx.font = "50px monospace";
          ctx.fillStyle = "white";
          ctx.textAlign = "center";
          message = won ? score > 180 ? "YOU WIN!" : "NOT BAD" : "GAME OVER";
          ctx.fillText(message, width / 2, height / 3);
          ctx.fillText(score * 100, width / 2, 2 * height / 3);
          return player.draw(X, Y);
        }, 1000);
      } else {
        return setTimeout(turn, 1000);
      }
    };
    paint();
    paint();
    setTimeout(turn, 1000);
    return $("#edit").unbind("click").click(function(event) {
      event.preventDefault();
      stopped = true;
      $("#code").toggle();
      return $("#play").toggle();
    });
  };
}).call(this);
