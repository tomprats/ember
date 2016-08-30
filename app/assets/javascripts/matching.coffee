$ ->
  updateSlides = (oldSlide) ->
    $.get "/refresh", (data) ->
      for slide in data.slides
        $newSlide = oldSlide.clone()
        $newSlide.attr("class", "slide " + slide.type)
        $newSlide.data({id: slide.id, "assessment-id": slide.assessment_id})
        $newSlide.find(".slide-caption").text(this.caption)
        $newSlide.find(".slide-image img").attr("src", this.image_desktop)
        $newSlide.find(".slide-badges").html("")
        for badge in slides.badges
          $badge = $("<div class='slide-badge'><img src='" + badge.toString() + "'></div>")
          $newSlide.find(".slide-badges").append($badge)
        $(".slides").append($newSlide)

      # Move loading slide to back
      $(".loading-slide").appendTo(".slides")

  $(document).on "click", ".me-not div", (e) ->
    e.preventDefault()
    $this = $(this)
    $slide = $this.closest(".slide")
    unless $slide.hasClass("prevent-default")
      $slide.addClass("prevent-default")
      slideType = if $slide.hasClass("user") then "user" else "slide"
      $.ajax {
        url: "/matching/" + $slide.data("id"),
        type: "put",
        data: { response: $this.hasClass("me"), assessment_id: $slide.data("assessment-id"), type: slideType },
        success: (data) ->
          $(".notifications").addClass("active") if data.notification
          if $(".slide").length <= 1
            $slide.remove()
            updateSlides($slide.clone())
          else
            $slide.remove()
      }
    false

  $(document).on "click", ".slide.user .slide-image", (e) ->
    e.preventDefault()
    $slide = $(this).parent()
    return false if $slide.find(".user-data")[0]
    $.get "/matching/" + $slide.data("id"), (data) ->
      $slide.append("<div class=\"user-data\">" +
        "<div class=\"section\"><h2>About</h2><span>" + data.user.about + "</span></div>" +
        "<div class=\"section\"><h2>Birthday</h2><span>" + data.user.birthday + "</span></div>" +
        "<div class=\"section\"><h2>Location</h2><span>" + data.user.location + "</span></div>"
      )
    false
