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
      $('#field_order').val(orderVal)
      $('#form_field_order').submit()
  }
  $('#dynamic_form_fields').on 'change', 'div.field.type select', ->
    type = $(this).val()
    form_field = $(this).parents('li.form_field.editing').first()
    option_form = $(this).parents('form.edit_form_field_option').first()
    if 'single choice' == type or 'multiple choice' == type
      $('div.edit_options', form_field).show('fast')
    else
      $('div.edit_options', form_field).hide('fast')
    if 'field' == type or 'area' == type
      $('.field.size', option_form).show('slow')
      $('> form .field.size', form_field).show('slow')
    else
      $('.field.size', option_form).hide('slow')
      $('> form .field.size', form_field).hide('slow')
    if 'count' == type
      $('> form .field.value', form_field).show('slow')
    else
      $('> form .field.value', form_field).hide('slow')

$(document).ready(initialize)
$(document).on('page:load', initialize)
