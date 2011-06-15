$(() ->
  stub = '''
function(
  land,   // what's in the block (str)
  togoal  // dist to/from next goal
) {
  var r = 0; // the ranking
  r += togoal*1;

  if (land == "field")
      r+= 0;
  else if (land == "crops")
      r+= 0;
  else if (land == "wood")
      r += 0;
  else if (land == "water")
      r += 0;
  else if (land == "mountain")
      r += 0;
  else if (land == "volcano")
      r += 0;
  else if (land == "meetup")
      r += 0;
  else if (land == "dragon")
      r += 0;
  return r;
}
'''
  $("#code textarea").val(stub)
  $("#code input").click( (event) ->
    event.preventDefault()
    try
      eval("window.rank = " + $("#code textarea").val())
      $("#code").toggle()
      $("#play").toggle()
      window.play()
    catch e
      alert(e)
  )
)