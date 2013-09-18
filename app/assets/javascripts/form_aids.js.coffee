initialize = ->
  $('section form input, section form select, section form textarea').change ->
    $('#done_page_editing').fadeOut();
  $('section form input, section form textarea').keyup ->
    $('#done_page_editing').fadeOut();
  if $('iframe.textedit').get(0)
    $($('iframe.textedit').get(0).contentWindow.document).keyup ->
      $('#done_page_editing').fadeOut();
  $('section form input[type=submit]').click ->
    $('#done_page_editing').fadeIn();

$(document).ready(initialize)
$(document).on('page:load', initialize)
