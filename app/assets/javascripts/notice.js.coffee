NOTICE = '#notice'

initialize = ->
  if $('#notice:empty').length == 0
    $('#notice').addClass('active')
    setTimeout (->
      $('#notice').removeClass('active')
    ), 8000
    

$(document).ready(initialize)
$(document).on('page:load', initialize)
