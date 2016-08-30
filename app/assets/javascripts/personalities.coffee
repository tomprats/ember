$ ->
  if $("body.personalities-show")[0]
    $personality = $(".personality")
    Traitify.setPublicKey($personality.data("key"))
    Traitify.setHost($personality.data("host"))
    Traitify.setVersion("v1")
    Traitify.ui.load($personality.data("id"), ".personality")
