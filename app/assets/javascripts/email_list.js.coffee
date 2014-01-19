initialize = ->
  $('body').on 'click', 'div.email_address_remover', ->
    address = $(this).attr('data-address')
    if address
      addresses = $.trim($('#remove_addresses').val() + '\n' + address)
      $('#remove_addresses').val(addresses)
      $(this).removeAttr('data-address').text('').parent().css('text-decoration', 'line-through')

$(document).ready(initialize)
$(document).on('page:load', initialize)
