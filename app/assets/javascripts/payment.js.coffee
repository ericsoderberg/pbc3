initialize = ->
  # event date picker
  $('#payment_received_at').datepicker {americanMode: true,changeYear: true}
  
  $('.filled_forms input[type="checkbox"]').on 'click', ->
    amount = parseInt $('#payment_amount').text(), 10
    change = parseInt $(this).attr('data-amount'), 10
    if $(this).attr('checked')
      $('#payment_amount').text(amount + change)
      $('#hidden_payment_amount').val(amount + change)
    else
      $('#payment_amount').text(amount - change)
      $('#hidden_payment_amount').val(amount - change)

  $('#choose_paypal').on 'click', (ev) ->
    $('#busy_overlay').show
    $("#denote_paypal").on('ajax:success', ->
        # submit to paypal
        $('#paypal_form').submit()
      ).
      submit()
    ev.preventDefault()
  
  $('#payment_submit').on 'click', ->
    $('#busy_overlay').show

$(document).ready initialize
$(document).on 'page:load', initialize
