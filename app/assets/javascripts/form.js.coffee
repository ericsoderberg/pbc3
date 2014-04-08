alignPaymentMethodControls = ->
  if $('#form_payable').length > 0
    $('.payment_method').toggle($('#form_payable')[0].checked)
    
checkLimit = (list) ->
  limit = list.attr('data-limit')
  if limit
    if $('input:checked', list).length >= limit
      $('input:not(:checked)', list).attr('disabled', 'disabled')
    else
      $('input:not(:checked):not(.disabled)', list).removeAttr('disabled')

initialize = ->
  $('#form_payable').on 'change', alignPaymentMethodControls
  alignPaymentMethodControls
  $('ul.dynamic_form_fields').sortable {
    axis: "y",
    cursor: "move",
    update: ->
      # strip "form_field_" prefix from each id to get list of ids
      orderVal =
        $('ul.dynamic_form_fields li.form_field').map((i, e) ->
          return $(e).attr('id').substring(11)).
          get().join(", ")
      # submit new order
      $('#field_order').val(orderVal)
      $('#form_field_order').submit()
  }
  $('ul.dynamic_form_sections').sortable {
    axis: "y",
    cursor: "move",
    update: ->
      # strip "form_section_" prefix from each id to get list of ids
      orderVal =
        $('ul.dynamic_form_sections li.form_section').map((i, e) ->
          return $(e).attr('id').substring(13)).
          get().join(", ")
      # submit new order
      $('#section_order').val(orderVal)
      $('#form_section_order').submit()
  }
  # adjust edit field inputs based on type
  $('ul.dynamic_form_sections').on 'change', 'form.edit_form_field div.header select', ->
    type = $(this).val()
    form_field = $(this).parents('li.form_field.editing').first()
    $('div.edit_options', form_field).toggleClass('active',
      'single choice' == type or 'multiple choice' == type)
    text_types = ['single line', 'multiple lines', 'field', 'area']
    $('> form .field.size', form_field).toggleClass('inactive', text_types.indexOf(type) == -1)
    $('> form .field.limit', form_field).toggleClass('inactive',
      'multiple choice' != type and 'count' != type)
    $('> form .field.prompt', form_field).toggleClass('inactive', 'instructions' == type)
  # enforce multiple choice limits
  $('#filled_sections').on 'change', 'ul.options_list input', ->
    list = $(this).parents('ul.options_list').first()
    checkLimit(list)
  $('#filled_sections ul.options_list').each (index, elem) ->
    checkLimit($(elem))
  # submit on sort change for fills index
  $('#filled_forms_sort select').on 'change', ->
    console.log('!!! change to', $(this).val())
    $(this).closest('form').submit()

$(document).ready(initialize)
$(document).on('page:load', initialize)
