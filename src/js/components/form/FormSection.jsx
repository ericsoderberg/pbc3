import React, { Component, PropTypes } from 'react';
import FormField from './FormField';
import formUtils from './formUtils';

const CLASS_ROOT = "form";

export default class FormSection extends Component {

  _onChange (filledForm) {
    this.props.onChange(filledForm);
  }

  render () {
    var formSection = this.props.formSection;

    var hidden = false;
    if (formSection.dependsOnId) {
      var dependsOn = formUtils.findFilledField(this.props.filledForm, formSection.dependsOnId);
      if (! dependsOn) {
        hidden = true;
      }
    }

    var result;

    if (hidden) {
      result = <span></span>;
    } else {
      var fields = formSection.formFields.map(function (formField) {
        return (
          <FormField key={formField.id}
            formField={formField}
            filledForm={this.props.filledForm}
            fieldErrors={this.props.fieldErrors}
            onChange={this._onChange} />
        );
      }, this);

      result = (
        <fieldset className={CLASS_ROOT + "__section"}>
          <legend className={CLASS_ROOT + "__section-header"}>
            <h2>{formSection.name}</h2>
          </legend>
          <div className="form__fields">
            {fields}
          </div>
        </fieldset>
      );
    }

    return result;
  }
};

FormSection.propTypes = {
  fieldErrors: PropTypes.object.isRequired,
  filledForm: PropTypes.object.isRequired,
  formSection: PropTypes.object.isRequired,
  onChange: PropTypes.func.isRequired
};
