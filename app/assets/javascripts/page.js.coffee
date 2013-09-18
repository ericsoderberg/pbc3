CONTAINER = 'div.regular_content'
ASIDE = 'ul.regular_aside'
  
initialize = ->
  $(CONTAINER).toggleClass('full', $(ASIDE).children().length == 0)

$(document).ready(initialize)
$(document).on('page:load', initialize)
