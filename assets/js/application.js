//= require jquery

var load = function() {
  $.ajax({
    type: "GET",
    url: "/word.json",
    dataType: "json"
  }).done(function(json) {
    $("#word").text(json.word);
    $("#mean").text(json.mean);
    $("#frequency").text(json.level);
  });
}

$(document).ready(function() {
  load();
  $("#clickableBox").click(function() {
    load();
  });
});
