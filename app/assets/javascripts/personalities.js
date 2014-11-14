$(document).ready(function() {
  if($("body.personalities-show").length) {
    var $personality = $(".personality");
    Traitify.setPublicKey($personality.data("key"));
    Traitify.setHost($personality.data("host"));
    Traitify.setVersion("v1");
    Traitify.ui.load($personality.data("id"), ".personality")
  }
});
