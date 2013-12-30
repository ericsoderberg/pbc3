alignPaymentMethodControls = ->
  if $('#form_payable').length > 0
    $('.payment_method').toggle($('#form_payable')[0].checked)

initialize = ->
  $('#form_payable').on 'change', alignPaymentMethodControls
  alignPaymentMethodControls
  $('#dynamic_form_fields').sortable {
    axis: "y",
    cursor: "move",
    update: ->
      # strip "form_field_" prefix from each id to get list of ids
      orderVal =
        $('#dynamic_form_fields li.form_field').map((i, e) ->
          return $(e).attr('id').substring(11)).
          get().join(", ")
      # submit new order
      $('#field_order').val(orderVal);
      $('#form_field_order').submit();
  }

$(document).ready(initialize)
$(document).on('page:load', initialize)
