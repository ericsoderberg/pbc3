# http://sixrevisions.com/tutorials/javascript_tutorial/create-a-slick-and-accessible-slideshow-using-jquery/
ready = ->
  
  slide = (position) ->
    
    # Hide / show controls
    manageControls position
    
    # Move slide_inner using margin-left
    $("#slide_inner").animate
      marginLeft: slideWidth * (-position)
    , 1500
  
  # manageControls: Hides and shows controls depending on currentPosition
  manageControls = (position) ->
    
    # Hide left arrow if position is first slide
    if position is 0 or showControls is false
      $("#banner_left_control").fadeOut()
    else
      $("#banner_left_control").fadeIn "slow"
    
    # Hide right arrow if position is last slide
    if position is numberOfSlides - 1 or showControls is false
      $("#banner_right_control").fadeOut()
    else
      $("#banner_right_control").fadeIn "slow"
  
  # only if we have something to animate
  if $("#animated_banners").length > 0
    currentPosition = 0
    slideWidth = $("#animated_banners").width()
    slideHeight = slideWidth / 2.2
    slides = $(".slide")
    numberOfSlides = slides.length
    automate = true
    showControls = false
  
    # Remove scrollbar in JS
    $("#animated_banners_list").css "overflow", "hidden"
    # Wrap all .slides with #slide_inner div
    # Float left to display horizontally, readjust .slides width
    slides.wrapAll("<div id=\"slide_inner\"/>").css
      float: "left"
      width: slideWidth
      height: slideHeight

    # Set #slide_inner width equal to total width of all slides
    $(".animated_banners_background").css
      width: slideWidth
      height: slideHeight
    $("#slide_inner").css
      width: slideWidth * numberOfSlides
      height: slideHeight
  
    # Insert left and right arrow controls in the DOM
    $("#animated_banners").prepend("<span class=\"control\" id=\"hero_left_control\">Move left</span>").append("<span class=\"control\" id=\"hero_right_control\">Move right</span>")
    
    # Create listeners for hovering to show controls
    $("#animated_banners").hover (->
      showControls = true
      manageControls currentPosition
    ), ->
      showControls = false
      manageControls currentPosition

    # Hide left arrow control on first load
    manageControls currentPosition
  
    # Create event listeners for .controls clicks
    $(".control").on "click", ->
      if automate
        automate = false
        clearInterval timer
      # Determine new position
      currentPosition = (if ($(this).attr("id") is "banner_right_control") then currentPosition + 1 else currentPosition - 1)
      slide currentPosition

    timer = setInterval(->
      currentPosition = currentPosition + 1
      currentPosition = 0  if currentPosition is numberOfSlides
      slide currentPosition
    , 10000)

$(document).ready(ready)
$(document).on('page:load', ready)
