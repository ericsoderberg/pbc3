initialized = false
       
initialize = ->
  
  if ! initialized && $('#home-gallery').length > 0
    initialized = true
    
    # Create listeners for hovering to show controls
    $("#home-gallery > li").hover (->
      $(this).addClass("active")
      $('#home-gallery').addClass("active")
    ), ->
      $('#home-gallery, #home-gallery li').removeClass("active")

$(document).ready(initialize)
$(document).on('page:load', initialize)
