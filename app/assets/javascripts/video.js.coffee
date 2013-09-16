CONTAINER = 'div.video-container, div.video-container iframe, div.video-container svg'
  
resize = ->
  windowWidth = $(window).width()
  width = 980
  height = 552
  if windowWidth < 1050
    width = (windowWidth - 40)
    height = Math.floor(width * 9 / 16)
  $(CONTAINER).attr({'width', width, 'height', height})

initialize = ->
  $(window).on 'resize', resize
  resize()

$(document).ready(initialize)
$(document).on('page:load', initialize)
