(function() {
  $(function() {
    var stub;
    stub = 'function(\n  land,   // what\'s in the block (str)\n  togoal  // dist to/from next goal\n) {\n  var r = 0; // the ranking\n\n  r += togoal*1;\n\n  if (land == "field")\n      r+= 0;\n  else if (land == "crops")\n      r+= 0;\n  else if (land == "wood")\n      r += 0;\n  else if (land == "water")\n      r += 0;\n  else if (land == "mountain")\n      r += 0;\n  else if (land == "volcano")\n      r += 0;\n  else if (land == "meetup")\n      r += 0;\n  else if (land == "dragon")\n      r += 0;\n  return r;\n}';
    $("#code textarea").val(stub);
    return $("#code input").click(function(event) {
      event.preventDefault();
      try {
        eval("window.rank = " + $("#code textarea").val());
        $("#code").toggle();
        $("#play").toggle();
        return window.play();
      } catch (e) {
        return alert(e);
      }
    });
  });
}).call(this);
