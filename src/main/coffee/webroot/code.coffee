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
      r += meetup*1;
  else
      r += dragon*1;
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
  else if (land == "meetup" && !bros)
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
  $("#edit").click( (event) ->
    event.preventDefault()
    $("#code").toggle()
    $("#play").toggle()
  )
)