CONTAINER = 'div.regular_content'
ASIDE = '.regular_aside'
  
initialize = ->
  emptyAside = (($(ASIDE, CONTAINER).length > 0 and 
    $(ASIDE, CONTAINER).children().length == 0) or
    $('aside', CONTAINER).children().length == 0)
  $(CONTAINER).toggleClass('full', emptyAside)

$(document).ready(initialize)
$(document).on('page:load', initialize)
