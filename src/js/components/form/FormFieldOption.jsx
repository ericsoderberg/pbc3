import React, { Component, PropTypes } from 'react';
import formUtils from './formUtils';

const CLASS_ROOT = "form";

export default class FormFieldOption extends Component {

  constructor () {
    super();
    this._onToggle = this._onToggle.bind(this);
  }

  _onToggle () {
    const { formFill, formField, formFieldOption } = this.props;
    var filledField = formUtils.findFilledField(formFill, formField.id);
    var filledFieldOption = formUtils.filledOptionForFormOption(formFill,
      formField, formFieldOption);

    if (! filledField) {
      filledField = {
        formFieldId: formField.id,
        filledFieldOptions: []
      };
      formFill.filledFields.push(filledField);
    }

    if (! filledFieldOption) {
      filledFieldOption = {
        value: formFieldOption.name,
        formFieldOptionId: formFieldOption.id
      };
      if ('single choice' === formField.fieldType) {
        filledField.filledFieldOptions = [filledFieldOption];
      } else {
        filledField.filledFieldOptions.push(filledFieldOption);
      }
    } else {
      filledField.filledFieldOptions =
        filledField.filledFieldOptions.filter(option => {
          return (option.formFieldOptionId !== formFieldOption.id);
        });
      if (filledField.filledFieldOptions.length === 0) {
        formFill.filledFields = formFill.filledFields.filter(field => {
          return (formField.id !== field.formFieldId);
        });
      }
    }
    this.props.onChange(formFill);
  }

  render () {
    const { formFill, formField, formFieldOption } = this.props;
    var filledFieldOption = formUtils.filledOptionForFormOption(formFill,
      formField, formFieldOption);

    let classes = [`${CLASS_ROOT}__field-option`];
    const checked = filledFieldOption ? true : false;
    if (checked) {
      classes.push(`${CLASS_ROOT}__field-option--active`);
    }

    let type, name;
    if ('single choice' === formField.fieldType) {
      type = "radio";
      name = formField.name;
    } else if ('multiple choice' === formField.fieldType) {
      type = "checkbox";
      name = formField.name + "[]";
    }

    let value;
    if (formFieldOption.value) {
      const prefix = formField.monetary ? '$' : '';
      value = (
        <span className="form__field-option-suffix">
          {prefix}{formFieldOption.value}
        </span>
      );
    }

    return (
      <div key={formFieldOption.id} className={classes.join(' ')}>
        <span>
          <input type={type} name={name} checked={checked}
            onChange={this._onToggle} />
          {formFieldOption.name}
        </span>
        <span className="form__field-option-help">
          {formFieldOption.help}
        </span>
        {value}
      </div>
    );
  }
};

FormFieldOption.propTypes = {
  formFill: PropTypes.object.isRequired,
  formField: PropTypes.object.isRequired,
  formFieldOption: PropTypes.object.isRequired,
  onChange: PropTypes.func.isRequired
};
