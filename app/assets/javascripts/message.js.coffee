initialize = ->
  # event date picker
  $('#message_date').datepicker {americanMode: true,changeYear: true}

$(document).ready(initialize)
$(document).on('page:load', initialize)
