initialize = ->
  $('#print_form_link').on 'click', (event) ->
    window.print()
    event.preventDefault() # Prevent link from following its href

$(document).ready(initialize)
$(document).on('page:load', initialize)
