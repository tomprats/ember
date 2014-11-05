$(document).ready(function() {
  $(".slide").append("<div class=\"me-not\"><div class=\"me\">Me</div><div class=\"not-me\">Not Me</div></div>");
  $(document).on("click", ".me-not div", function(e) {
    e.preventDefault();
    var $this = $(this);
    var $slide = $this.closest(".slide");
    if(!$slide.hasClass("prevent-default")) {
      $slide.addClass("prevent-default")
      $.ajax({
        url: "/matching/" + $slide.data("id"),
        type: "put",
        data: { response: $this.hasClass("me") },
        success: function(data) {
          if(data.notification) {
            $(".notifications").addClass("active");
          }
          if($(".slide").length <= 1) {
            $slide.remove();
            updateSlides($slide.clone());
          } else {
            $slide.remove();
          }
        }
      });
    }
    return false;
  });

  $(document).on("click", ".slide.user .slide-image", function(e) {
    e.preventDefault();
    $slide = $(this).parent();
    if($slide.find(".user-data").length) { return false; }
    $.get("/matching/" + $slide.data("id"), function(data) {
      $slide.append("<div class=\"user-data\">" +
        "<div class=\"section\"><h2>About</h2><span>" + data.user.about + "</span></div>" +
        "<div class=\"section\"><h2>Birthday</h2><span>" + data.user.birthday + "</span></div>" +
        "<div class=\"section\"><h2>Location</h2><span>" + data.user.location + "</span></div>"
      );
    });
    return false;
  });
});

function updateSlides(slide) {
  $.get("/refresh", function(data) {
    $(data.slides).each(function() {
      var $newSlide = slide.clone();
      $newSlide.attr("class", "slide " + this.type);
      $newSlide.find(".slide-caption").text(this.caption);
      $newSlide.find(".slide-image img").attr("src", this.image_desktop);
      $(".slides").append($newSlide);
    });
    // Move loading slide to back
    $(".loading-slide").appendTo(".slides");
  });
}
