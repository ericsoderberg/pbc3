function _onBlur (event) {
  // clear any form__field--focus
  var elements = document.querySelectorAll('.form__field--focus');
  for (var i=0; i<elements.length; i++) {
    elements[i].classList.remove('form__field--focus');
  }
};

function _onFocus (event) {
  // If this is an input element inside a form__field, set the form_field focus
  var element = event.target.parentNode
  while (element) {
    if (element.classList.contains('form__field')) {
      element.classList.add('form__field--focus');
      break;
    }
    element = element.parentNode;
  }
};

document.addEventListener('blur', _onBlur , true);
document.addEventListener('focus', _onFocus , true);
