$(() ->
  board = $("#board")
  width = board.width()
  height = board.height()
  blocks = 10
  blockW = width / blocks
  blockH = height / blocks
  
  score = 0

  tiles =
    field:
      chance: (x,y) -> 
        if y > 7 then 5
        else if y > 2 then 3
        else 1
      enter: () -> player.score(4)
    wood:
      chance: (x,y) -> 
        if y > 3 and y < 9 then 3
        else 0
      enter: () -> player.hit(2)
    crops:
      chance: (x,y) -> 
        if y > 4 then 1
        else 0
      enter: () -> player.score(10)
    water:
      chance: (x,y) -> 
        if y > 2 and y < 5 then 10
        else 0
      enter: () -> player.hit(10)
    mountain:
      chance: (x,y) -> 
        if y < 2 then 5
        if y < 8 then 1
        else 0
      enter: () -> player.hit(4)
    volcano:
      chance: (x,y) -> 
        if y <2 then 1
        else 0
      enter: () -> player.hit(20)
    meetup:
      chance: (x,y) -> 0
      enter: () ->
        player.score(50)
        player = group
    dragon:
      chance: (x,y) -> 0
      enter: () -> player.score(100)

  setupimg = (name) ->
    img = new Image()
    img.src = "tiles/#{name}.png"
    img
  for name of tiles
    tiles[name].img = setupimg(name)
  pick = (x,y) ->
    die = []
    for name of tiles
      tile = tiles[name]
      for i in [0...tile.chance(x,y)]
        die.push(tile)
    die[Math.floor(Math.random()*die.length)]
  grid = (([x,y,pick(x,y)] for x in [0...blocks]) for y in [0...blocks])
  assign = (x,y,tile) -> grid[y][x] = [x,y,tile]
  lookup = (x,y) -> grid[y][x][2]
  assign(8,6,tiles.meetup)
  assign(2,0,tiles.dragon)

  canvas = board[0]
  ctx = canvas.getContext("2d")
  xblock = (x, y, f) ->
    ctx.save()
    ctx.translate(x*blockW, y*blockH)
    f()
    ctx.restore()

  solo =
    img: setupimg("elf")
    draw: (x, y) ->
      xblock(x, y, () ->
        ctx.drawImage(solo.img, 0, 0, blockW, blockH) 
      )
    score: (s) -> score += s
    hit: (s) -> score -= s
  group =
    img: setupimg("group")
    draw: (x,y) ->
      xblock(x-1, y, () ->
        ctx.drawImage(group.img, 0, 0, 3*blockW, blockH)
      )
    score: (s) -> score += s
    hit: (s) -> score -= s/2

  player = solo
  X = 0
  Y = 9

  paint = () ->
    for row in grid
      for [x,y,tile] in row
        xblock(x, y, () ->
          ctx.drawImage(tile.img, 0, 0, blockW, blockH)
        )
    player.draw(X, Y)

  turn = () ->
    X += 1
    Y -= 1
    if X < blocks
      lookup(X,Y).enter()
      paint()
      $("#score").text(score*100)
      setTimeout(turn, 1000)

  calcdirs = () ->
    dirs = [
      [X+1,Y]
      [X-1,Y]
      [X,Y+1]
      [X,Y-1]
    ]
    dirs = [[x,y,lookup(x,y)] for [x,y] in dirs when
            x > 0 && x < blocks && y > 0 && y < blocks]
    

  metup = false
  decide = (dirs) ->
    rank(dir) ->
      r = 0
      if not metup
        r += 5 if dir.meetup
      else
        r += 5 if dir.dragon
      switch dir.next
        when "field" then r+= 2
        when "crop" then r+= 5
        when "wood" then r -= 2
        when "water" then r -= 2
        when "mountain" then r -= 1
        when "volcano" then r -= 3
        when "meetup" then r += 10
        when "dragon" then r += 10

    dirs.sort((a, b,) -> rank(a) - rank(b))
    dirs[0]
      
    

  paint()
  setTimeout(turn, 1000)
)
