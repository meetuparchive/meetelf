$(() ->
  board = $("#board")
  width = board.width()
  height = board.height()
  blocks = 10
  blockW = width / blocks
  blockH = height / blocks
  
  tiles = {
    field: { img: "f" }
    wood:  { img: "w" }
    brush: { img: "b" }
    rock:  { img: "r" }
    water: { img: "w" }
    fire:  { img: "!" }
  }
  tilesAry = (tiles[k] for k of tiles)
  console.log(tilesAry)
  pick = (x,y) -> tilesAry[Math.floor(Math.random()*tilesAry.length)]
  grid = (([x,y,pick(x,y)] for x in [0...blocks]) for y in [0...blocks])
  paint = () ->
    canvas = board[0]
    ctx = canvas.getContext("2d")

    for row in grid
      for [x,y,tile] in row
        ctx.save()
        ctx.translate(x*blockW, y*blockH)
        ctx.fillText(tile.img, blockW/2, blockH/2)
        ctx.restore()

  paint()
)
