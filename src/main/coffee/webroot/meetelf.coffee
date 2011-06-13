$(() ->
  board = $("#board")
  width = board.width()
  height = board.height()
  blocks = 10
  blockW = width / blocks
  blockH = height / blocks
  
  tiles = {
    field: { }
    wood:  { }
    crops: { }
    mountain:  { }
    water: { }
    volcano:  { }
  }
  for name of tiles
      img = new Image()
      img.src = "tiles/#{name}.png"
      tiles[name]["img"] = img
  tilesAry = (tiles[k] for k of tiles)
  pick = (x,y) -> tilesAry[Math.floor(Math.random()*tilesAry.length)]
  grid = (([x,y,pick(x,y)] for x in [0...blocks]) for y in [0...blocks])
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
