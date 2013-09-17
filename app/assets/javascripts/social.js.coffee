CONTAINER = 'div#social iframe'
  
resize = ->
  windowWidth = $(window).width()
  width = 400
  height = 300
  if windowWidth < 440
    width = (windowWidth - 40)
    height = Math.floor(width * 3 / 4)
  $(CONTAINER).attr({'width', width, 'height', height}).css({'width', width, 'height', height})

initialize = ->
  $(window).on 'resize', resize
  resize()

$(document).ready(initialize)
$(document).on('page:load', initialize)
