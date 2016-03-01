module.exports = {

  filledOptionForFormOption: function (formFill, formField, formFieldOption) {
    var result;
    formFill.filledFields.some(filledField => {
      if (formField.id === filledField.formFieldId) {
        return filledField.filledFieldOptions.some(filledFieldOption => {
          if (filledFieldOption.formFieldOptionId === formFieldOption.id) {
            result = filledFieldOption;
            return true;
          }
        });
      }
    });
    return result;
  },

  findFilledField: function (formFill, formFieldId) {
    var result;
    formFill.filledFields.some(filledField => {
      if (filledField.formFieldId === formFieldId) {
        result = filledField;
        return true;
      }
    });
    return result;
  },

  findFormField: function (form, formFieldId) {
    var result;
    form.formSections.some(formSection => {
      return formSection.formFields.some(formField => {
        if (formField.id === formFieldId) {
          result = formField;
          return true;
        }
      });
    });
    return result;
  }
  
};
