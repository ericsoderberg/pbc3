alignPaymentMethodControls = ->
  if $('#form_payable').length > 0
    $('.payment_method').toggle($('#form_payable')[0].checked)

initialize = ->
  $('#form_payable').on 'change', alignPaymentMethodControls
  alignPaymentMethodControls

$(document).ready(initialize)
$(document).on('page:load', initialize)
