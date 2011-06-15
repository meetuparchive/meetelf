$(() ->
  board = $("#board")
  width = board.width()
  height = board.height()
  blocks = 10
  blockW = width / blocks
  blockH = height / blocks
  
  score = 0
  X = 0
  Y = 9

  canvas = board[0]
  ctx = canvas.getContext("2d")
  xblock = (x, y, f) ->
    ctx.save()
    ctx.translate(x*blockW, y*blockH)
    f()
    ctx.restore()

  setupimg = (name) ->
    img = new Image()
    img.src = "tiles/#{name}.png"
    img

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
  won = false

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
      enter: () ->
        player.score(100)
        won = true

  for name of tiles
    tiles[name].img = setupimg(name)
    tiles[name].name = name
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

  paint = () ->
    for row in grid
      for [x,y,tile] in row
        xblock(x, y, () ->
          ctx.drawImage(tile.img, 0, 0, blockW, blockH)
        )
    player.draw(X, Y)

  rank = (dir, metup) ->
    r = 0
    if not metup
      r += dir.meetup * 5
    else
      r += dir.dragon * 5
    switch dir.next
      when "field" then r+= 2
      when "crop" then r+= 5
      when "wood" then r -= 2
      when "water" then r -= 2
      when "mountain" then r -= 1
      when "volcano" then r -= 3
      when "meetup" and not metup then r += 10
      when "dragon" then r += 10
    r

  sqrs = (ax, ay, cx, cy) ->
    (ax - cx)*(ax - cx) + (ay - cy)*(ay - cy)
  toPoint = (x, y, cx, cy) ->
    Math.sqrt(sqrs(x, y, X, Y)) - Math.sqrt(sqrs(x, y, cx, cy))
  toMeetup = (cx, cy) -> toPoint(8, 6, cx, cy)
  toDragon = (cx, cy) -> toPoint(2, 0, cx, cy)

  turn = () ->
    ways = []
    for x in [-1..1]
      for y in [-1..1]
        ways.push([X+x,Y+y]) if x != 0 || y != 0
    ingrid = (n) -> n >= 0 && n < blocks
    valid = ([x, y] for [x,y] in ways when ingrid(x) && ingrid(y))
    ranked = ([x, y, rank(
      next: lookup(x,y).name
      meetup: toMeetup(x,y)
      dragon: toDragon(x,y)
    , player == group)] for [x, y] in valid)
    ranked.sort((a,b) -> b[2] - a[2])
    [x,y,r] = ranked[0]
    X = x
    Y = y
    lookup(X,Y).enter()
    paint()
    $("#score").text(score*100)
    if not won then setTimeout(turn, 1000)

  paint()
  setTimeout(turn, 1000)
)
