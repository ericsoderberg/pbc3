import React, { Component, PropTypes } from 'react';
import FormField from './FormField';
import formUtils from './formUtils';

const CLASS_ROOT = "form";

export default class FormSection extends Component {

  constructor () {
    super();
    this._onChange = this._onChange.bind(this);
  }

  _onChange (formFill) {
    this.props.onChange(formFill);
  }

  render () {
    const { formSection, formFill, errors } = this.props;

    let hidden = false;
    if (formSection.dependsOnId) {
      const dependsOn = formUtils.findFilledField(formFill, formSection.dependsOnId);
      if (! dependsOn) {
        hidden = true;
      }
    }

    let result;
    if (hidden) {
      result = <span></span>;
    } else {
      const fields = formSection.formFields.map(formField => {
        return (
          <FormField key={formField.id}
            formField={formField}
            formFill={formFill}
            errors={errors}
            onChange={this._onChange} />
        );
      });

      result = (
        <fieldset className={`${CLASS_ROOT}__section`}>
          <legend className={`${CLASS_ROOT}__section-header`}>
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
  errors: PropTypes.object,
  formFill: PropTypes.object.isRequired,
  formSection: PropTypes.object.isRequired,
  onChange: PropTypes.func.isRequired
};
