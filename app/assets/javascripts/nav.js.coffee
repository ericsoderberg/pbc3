MENU_PARENT = '#site_nav .menu_parent'

closeMenu = (event) ->
  if $(event.target).parents(MENU_PARENT).length == 0
    $(MENU_PARENT).removeClass('open')
    $(document.body).off 'click', closeMenu
  
clickMenu = ->
  if ! $(this).hasClass('open')
    $(MENU_PARENT).removeClass('open') # close any others
    $(this).addClass('open')
    setTimeout((->
      $(document.body).on 'click', closeMenu
      ), 50)
  else
    $(MENU_PARENT).removeClass('open')

initialize = ->
  $(document.body).on 'click', MENU_PARENT, clickMenu
    

$(document).ready(initialize)
$(document).on('page:load', initialize)
