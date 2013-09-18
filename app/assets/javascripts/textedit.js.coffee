initialize = ->
  $('.textedit').rte({
    content_css_url: "/assets/rte-light/rte.css",
    media_url: "/assets/rte-light/",
    height: 400,
    width: 500
  });

$(document).ready(initialize)
$(document).on('page:load', initialize)
