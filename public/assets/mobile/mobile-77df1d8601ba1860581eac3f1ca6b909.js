(function() {
  var ready;

  ready = function() {
    var automate, currentPosition, manageControls, numberOfSlides, showControls, slide, slideHeight, slideWidth, slides, timer;
    slide = function(position) {
      manageControls(position);
      return $("#slide_inner").animate({
        marginLeft: slideWidth * (-position)
      }, 1500);
    };
    manageControls = function(position) {
      if (position === 0 || showControls === false) {
        $("#banner_left_control").fadeOut();
      } else {
        $("#banner_left_control").fadeIn("slow");
      }
      if (position === numberOfSlides - 1 || showControls === false) {
        return $("#banner_right_control").fadeOut();
      } else {
        return $("#banner_right_control").fadeIn("slow");
      }
    };
    if ($("#animated_banners").length > 0) {
      currentPosition = 0;
      slideWidth = $("#animated_banners").width();
      slideHeight = slideWidth / 2.2;
      slides = $(".slide");
      numberOfSlides = slides.length;
      automate = true;
      showControls = false;
      $("#animated_banners_list").css("overflow", "hidden");
      slides.wrapAll("<div id=\"slide_inner\"/>").css({
        float: "left",
        width: slideWidth,
        height: slideHeight
      });
      $(".animated_banners_background").css({
        width: slideWidth,
        height: slideHeight
      });
      $("#slide_inner").css({
        width: slideWidth * numberOfSlides,
        height: slideHeight
      });
      $("#animated_banners").prepend("<span class=\"control\" id=\"hero_left_control\">Move left</span>").append("<span class=\"control\" id=\"hero_right_control\">Move right</span>");
      $("#animated_banners").hover((function() {
        showControls = true;
        return manageControls(currentPosition);
      }), function() {
        showControls = false;
        return manageControls(currentPosition);
      });
      manageControls(currentPosition);
      $(".control").on("click", function() {
        if (automate) {
          automate = false;
          clearInterval(timer);
        }
        currentPosition = ($(this).attr("id") === "banner_right_control" ? currentPosition + 1 : currentPosition - 1);
        return slide(currentPosition);
      });
      return timer = setInterval(function() {
        currentPosition = currentPosition + 1;
        if (currentPosition === numberOfSlides) {
          currentPosition = 0;
        }
        return slide(currentPosition);
      }, 10000);
    }
  };

  $(document).ready(ready);

  $(document).on('page:load', ready);

}).call(this);
(function() {
  var ready;

  ready = function() {
    var NAV, onBodyClick, toggleNav;
    NAV = 'header ul.nav';
    onBodyClick = function(event) {
      console.log(event.target);
      if (event.target !== $(NAV)[0] && $(event.target).parents(NAV).length === 0) {
        $(NAV).removeClass('active');
        return $('body').off('click', onBodyClick);
      }
    };
    toggleNav = function(event) {
      $(NAV).toggleClass('active');
      if ($(NAV).hasClass('active')) {
        return $('body').on('click', onBodyClick);
      } else {
        return $('body').off('click', onBodyClick);
      }
    };
    return $(NAV).on('click', toggleNav);
  };

  $(document).ready(ready);

  $(document).on('page:load', ready);

}).call(this);
