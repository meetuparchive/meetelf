$(() ->
  board = $("#board")
  width = board.width()
  height = board.height()
  blocks = 10
  blockW = width / blocks
  blockH = height / blocks
  
  tiles =
    field:
      chance: (x,y) -> 
        if y > 7 then 5
        else if y > 2 then 3
        else 1
    wood:
      chance: (x,y) -> 
        if y > 3 and y < 9 then 3
        else 0
    crops:
      chance: (x,y) -> 
        if y > 4 then 1
        else 0
    water:
      chance: (x,y) -> 
        if y > 2 and y < 5 then 10
        else 0
    mountain:
      chance: (x,y) -> 
        if y < 2 then 5
        if y < 8 then 1
        else 0
    volcano:
      chance: (x,y) -> 
        if y <2 then 1
        else 0
    meetup:
      chance: (x,y) -> 0
    dragon:
      chance: (x,y) -> 0

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
  group =
    img: setupimg("group")
    draw: (x,y) ->
      xblock(x-1, y, () ->
        ctx.drawImage(group.img, 0, 0, 3*blockW, blockH)
      )

  player = solo

  paint = () ->
    for row in grid
      for [x,y,tile] in row
        xblock(x, y, () ->
          ctx.drawImage(tile.img, 0, 0, blockW, blockH)
        )

    player.draw(0,9)

  paint()
)
