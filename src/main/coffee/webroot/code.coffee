$(() ->
  stub = '''
function(
  land,   // what's in the block (str)
  togoal  // dist to/from next goal
) {
  var landfactor = {
    field: 0,
    crops: 0,
    wood: 0,
    water: 0,
    mountain: 0,
    volcano: 0,
    meetup: 0,
    dragon: 0
  }

  return landfactor[land] + togoal*1;
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