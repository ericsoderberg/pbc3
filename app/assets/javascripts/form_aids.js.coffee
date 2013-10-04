initialize = ->
  $('section form input, section form select, section form textarea').change ->
    $('#done_page_editing').fadeOut()
  $('section form input, section form textarea').keyup ->
    $('#done_page_editing').fadeOut()
  if $('iframe.textedit').get(0)
    $($('iframe.textedit').get(0).contentWindow.document).keyup ->
      $('#done_page_editing').fadeOut()
  $('#page_parent_feature').change ->
    $("#parent_feature_indexer").toggle($('#page_parent_feature')[0].checked)
  $('#page_home_feature').change ->
    $("#home_feature_indexer").toggle($('#page_home_feature')[0].checked)
  $('section form input[type=submit]').click ->
    $('#done_page_editing').fadeIn()
  $('#parent_indexer').sortable {
    axis: "y",
    cursor: "move",
    update: ->
      orderVal =
        $('#parent_indexer li').map((i, e) ->
          return $(e).attr('id')).
          get().join(", ")
      $('#parent_feature_order').val(orderVal)
  }
  $('select.page').select2({width: 'element'});
  $('select.event').select2({width: 'element'});
  $('select.email_list').select2({width: 'element'});

$(document).ready(initialize)
$(document).on('page:load', initialize)
