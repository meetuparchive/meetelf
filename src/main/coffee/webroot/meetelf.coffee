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

  for name of tiles
    img = new Image()
    img.src = "tiles/#{name}.png"
    tiles[name]["img"] = img
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

  paint = () ->
    canvas = board[0]
    ctx = canvas.getContext("2d")

    for row in grid
      for [x,y,tile] in row
        ctx.save()
        ctx.translate(x*blockW, y*blockH)
        ctx.drawImage(tile.img, 0, 0, blockW, blockH)
        ctx.restore()

  paint()
)
