//= require jquery

$(document).ready(function() {
  $(".clickableBox").click(function() {
    console.log("click");
    var form = $("#searchForm")[0];
    form.submit();
  });
});
