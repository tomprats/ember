$ ->
  $(document).on "click", ".close", (e) ->
    e.preventDefault()
    $(this).parent().remove()
    false
