(function() {
  $(function() {
    var stub;
    stub = 'function(\n  land,   // what\'s in the block (str)\n  togoal  // dist to/from next goal\n) {\n  var landfactor = {\n    field: 0,\n    crops: 0,\n    wood: 0,\n    water: 0,\n    mountain: 0,\n    volcano: 0,\n    meetup: 0,\n    dragon: 0\n  }\n\n  return landfactor[land] + togoal*1;\n}';
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
