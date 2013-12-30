initialize = ->
  # audio date picker
  $('#audio_date').datepicker {americanMode: true,changeYear: true}

$(document).ready(initialize)
$(document).on('page:load', initialize)
