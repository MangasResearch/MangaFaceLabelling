$(document).read(function(){
  $.get("http://ipinfo.io", function(response) {
     Shiny.onInputChange("getIp", response);
  }, "json");
});