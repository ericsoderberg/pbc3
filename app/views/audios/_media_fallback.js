$(function() {
  if (!Modernizr.audio.mp3) {
    $('.fallback_mp3').show();
    $('audio').hide();
  }
});
