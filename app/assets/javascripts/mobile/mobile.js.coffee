#= require_directory .

ready = ->
  
  NAV = 'header ul.nav'
  
  onBodyClick = (event) ->
    console.log event.target
    if event.target != $(NAV)[0] and $(event.target).parents(NAV).length == 0
      $(NAV).removeClass('active')
      $('body').off 'click', onBodyClick
      
  toggleNav = (event) ->
    $(NAV).toggleClass('active')
    if $(NAV).hasClass('active')
      $('body').on 'click', onBodyClick
    else
      $('body').off 'click', onBodyClick
  
  $(NAV).on 'click', toggleNav

$(document).ready(ready)
$(document).on('page:load', ready)
