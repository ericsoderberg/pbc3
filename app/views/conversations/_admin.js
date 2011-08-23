$(function() {
  $('.new_comment form').hide();
  $('a.new_comment').click(function () {
    $('.new_comment form').fadeIn();
    $('a.new_comment').hide();
    return (false);
  });
  $('.new_comment .cancel').click(function () {
    $('.new_comment form').fadeOut();
    $('a.new_comment').fadeIn();
    return (false);
  });
  $('.new_comment form').live("ajax:success", function (evt, data, status, xhr) {
    var $form = $(this);
    $form.find('textarea,input[type="text"]').val("");
    $form.closest('.conversation').find('.comments').append(xhr.responseText);
    $('.new_comment form').fadeOut();
    $('a.new_comment').fadeIn();
  })
  $('.comment .delete').live("ajax:success", function (evt, data, status, xhr) {
    $(this).closest('li').remove();
  })
});
