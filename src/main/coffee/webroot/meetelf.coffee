$(() ->
  board = $("#board")
  width = board.width()
  height = board.height()
  console.log(width)
  console.log(height)
  blocks = 10
  blockW = width / blocks
  blockH = height / blocks
  grid = (([x,y] for x in [0...blocks]) for y in [0...blocks])
  paint = () ->
    canvas = board[0]
    ctx = canvas.getContext("2d")

    for row in grid
      for [x,y] in row
        ctx.save()
        ctx.translate(x*blockW, y*blockH)
        ctx.fillText("#{x},#{y}", blockW/2, blockH/2)
        ctx.restore()

  paint()
)
