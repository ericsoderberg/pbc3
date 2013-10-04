initialize = ->
  $('#newsletter_published_at').datepicker({
    americanMode: true,
    changeYear: true
  })

$(document).ready(initialize)
$(document).on('page:load', initialize)
