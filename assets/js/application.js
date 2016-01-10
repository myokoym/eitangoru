//= require jquery

var load = function() {
  $.ajax({
    type: "GET",
    url: "/word.json",
    dataType: "json"
  }).done(function(json) {
    $("h2.word").text(json.word);
    $("p.lead").text(json.mean);
    $("#frequency").text(json.level);
  });
}

$(document).ready(function() {
  load();
  $(".clickableBox").click(function() {
    load();
  });
});
