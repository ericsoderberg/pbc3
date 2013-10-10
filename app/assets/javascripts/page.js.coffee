CONTAINER = 'div.regular_content'
ASIDE = '.regular_aside'

showHideIndexer = ->
  $('#indexer').parent().toggle($('#indexer').children().length > 1)

updateIndexer = (siblings) ->
  if siblings.length > 1
    text = $.map(siblings, (s) ->
      return s.id).join(', ')
    $('#sub_order').val(text)
    $('#indexer').empty()
    $.each(siblings, (index, sibling) ->
      li = $('<li></li>').text(sibling.name)
      if sibling.url == $('#indexer').attr('data-page-url')
        li.addClass('active')
      $('#indexer').append(li))
  showHideIndexer()

resetIndexer = ->
  $.ajax({
    url: "/pages/" + $('#indexer').attr('data-page-url') + '/edit_for_parent' +
      "?parent_id=" + $('#page_parent_id').val(),
    cache: false,
    success: updateIndexer
  })

initialize = ->
  emptyAside = (($(ASIDE, CONTAINER).length > 0 and
    $(ASIDE, CONTAINER).children().length == 0) or
    $('aside', CONTAINER).children().length == 0)
  $(CONTAINER).toggleClass('full', emptyAside)
  
  $('#indexer').sortable({
    axis: "y",
    cursor: "move",
    update: ->
      orderVal =
        $('#indexer li').map((i, e) ->
          return $(e).attr('id')
        ).get().join(", ")
      $('#sub_order').val(orderVal)
  })
  
  $('#page_parent_id').on 'change', resetIndexer
  showHideIndexer()

$(document).ready(initialize)
$(document).on('page:load', initialize)
