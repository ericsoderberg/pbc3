initialize = ->
  $('#page_gallery').addClass('loading')
  setTimeout(( ->
    $('#page_gallery').removeClass('loading').addClass('loaded')
  ), 300);

$(document).ready(initialize)
$(document).on('page:load', initialize)
