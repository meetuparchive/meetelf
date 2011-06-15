$(() ->
  stub = '''
function(
  land,    // what's in the block (str)
  meetup,  // dist to/from meetup (num)
  dragon,  // dist to/from dragon (num)
  bros     // has been to meetup? (bool)
) {
  var r = 0; // the ranking
  if (!bros)
      r += meetup * 2
  else
      r += dragon * 4;
  if (land == "field")
      r+= 2;
  else if (land == "crops")
      r+= 4;
  else if (land == "wood")
      r -= 2;
  else if (land == "water")
      r -= 2;
  else if (land == "mountain")
      r -= 1;
  else if (land == "volcano")
      r -= 3;
  else if (land == "meetup" && !bros)
      r += 10
  else if (land == "dragon")
      r += 10
  return r
}
'''
  $("#code textarea").val(stub)
  $("#code input").click( (event) ->
    event.preventDefault()
    eval("window.rank = " + $("#code textarea").val())
    $("#code").toggle()
    $("#play").toggle()
    window.play()
  )
  $("#edit").click( (event) ->
    event.preventDefault()
    $("#code").toggle()
    $("#play").toggle()
  )
)