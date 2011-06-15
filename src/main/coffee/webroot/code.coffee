$(() ->
  stub = '''
function(dir, metup) {
    var r = 0;
    if (!metup)
        r += dir.meetup * 3;
    else
        r += dir.dragon * 3;
    if (dir.next == "field")
        r+= 2;
    else if (dir.next == "crop")
        r+= 5;
    else if (dir.next == "wood")
        r -= 2;
    else if (dir.next == "water")
        r -= 2;
    else if (dir.next == "mountain")
        r -= 1;
    else if (dir.next == "volcano")
        r -= 3;
    else if (dir.next == "meetup" && !metup)
        r += 10
    else if (dir.next == "dragon")
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
    setTimeout(window.play, 1000)
  )
  $("#edit").click( (event) ->
    event.preventDefault()
    $("#code").toggle()
    $("#play").toggle()
  )
)