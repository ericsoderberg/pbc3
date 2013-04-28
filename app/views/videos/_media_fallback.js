$(function() {
  if (!Modernizr.video) {
    $('.fallback_video').show();
    $('video').hide();
  }
});