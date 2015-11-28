module.exports = {
  filledOptionForFormOption: function (filledForm, formField, formFieldOption) {
    var result;
    filledForm.filledFields.some(function (filledField) {
      if (formField.id === filledField.formFieldId) {
        return filledField.filledFieldOptions.some(function (filledFieldOption) {
          if (filledFieldOption.formFieldOptionId === formFieldOption.id) {
            result = filledFieldOption;
            return true;
          }
        });
      }
    });
    return result;
  },

  findFilledField: function (filledForm, formFieldId) {
    var result;
    filledForm.filledFields.some(function (filledField) {
      if (filledField.formFieldId === formFieldId) {
        result = filledField;
        return true;
      }
    });
    return result;
  },

  findFormField: function (form, formFieldId) {
    var result;
    form.formSections.some(function (formSection) {
      return formSection.formFields.some(function (formField) {
        if (formField.id === formFieldId) {
          result = formField;
          return true;
        }
      });
    });
    return result;
  }
}
