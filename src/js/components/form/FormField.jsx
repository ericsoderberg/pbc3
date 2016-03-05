import React, { Component, PropTypes } from 'react';
import FormFieldOption from './FormFieldOption';
import formUtils from './formUtils';

const CLASS_ROOT = "form__field";

export default class FormField extends Component {

  constructor () {
    super();
    this._onChange = this._onChange.bind(this);
  }

  _onChange (event) {
    const { formFill, formField } = this.props;
    const value = event.target.value;
    let filledField = formUtils.findFilledField(formFill, formField.id);
    if (value) {
      if (! filledField) {
        filledField = {formFieldId: formField.id};
        formFill.filledFields.push(filledField);
      }
      filledField.value = value;
    } else {
      formFill.filledFields = formFill.filledFields.filter(field => {
        return (formField.id !== field.formFieldId);
      });
    }
    this.props.onChange(formFill);
  }

  render () {
    const { formFill, formField, errors } = this.props;
    const filledField = formUtils.findFilledField(formFill, formField.id);
    let classes = [CLASS_ROOT];
    let hidden = false;
    if (formField.dependsOnId) {
      const dependsOn = formUtils.findFilledField(formFill, formField.dependsOnId);
      if (! dependsOn) {
        hidden = true;
      }
    }

    let result;
    if (hidden) {

      result = <span></span>;

    } else if ('instructions' === formField.fieldType) {

      result = (
        <div className={`${CLASS_ROOT} form__fields-help`}>
          {formField.help}
        </div>
      );

    } else {

      let label;
      if (formField.name) {
        label = <label>{formField.name}</label>;
      }
      let help;
      if (formField.help) {
        help = <div className={`${CLASS_ROOT}-help`}>{formField.help}</div>;
      }
      let error;
      if (errors.hasOwnProperty(formField.name.toLowerCase())) {
        classes.push(`${CLASS_ROOT}--error`);
        error = (
          <div className={`${CLASS_ROOT}-error`}>
            {errors[formField.name.toLowerCase()].join(', ')}
          </div>
        );
      }

      let content;
      const value = filledField ? filledField.value : formField.value;
      if ('single line' === formField.fieldType) {
        content = (
          <input ref="input" type="text" name={formField.name} value={value}
            onChange={this._onChange} />
        );
        if (formField.monetary) {
          content = (
            <div className={`${CLASS_ROOT}-decorated-input`} >
              <span className={`${CLASS_ROOT}-decorated-input-prefix`}>$</span>
              {content}
            </div>
          );
        }
      } else if ('multiple lines' === formField.fieldType) {
        content = (
          <textarea ref="input" name={formField.name} value={value}
            onChange={this._onChange} />
        );
      } else if ('single choice' === formField.fieldType ||
        'multiple choice' === formField.fieldType) {
        content = formField.formFieldOptions.map(formFieldOption => {
          return (
            <FormFieldOption key={formFieldOption.id}
              formField={formField}
              formFieldOption={formFieldOption}
              formFill={formFill}
              onChange={this.props.onChange} />
          );
        });
      } else if ('count' === formField.fieldType) {
        var suffix = `x ${formField.monetary ? '$' : ''}${formField.unitValue}`;
        if (value) {
          suffix += ` = ${formField.monetary ? '$' : ''}${formField.unitValue * value}`;
        }
        content = (
          <div className={`${CLASS_ROOT}-decorated-input`}>
            <input ref="input" type="number" name={formField.name}
              value={value} onChange={this._onChange} />
            <span className={`${CLASS_ROOT}-decorated-input-suffix`}>{suffix}</span>
          </div>
        );
      }

      result = (
        <div className={classes.join(' ')}>
          {error}
          {label}
          {help}
          {content}
        </div>
      );
    }

    return result;
  }
};

FormField.propTypes = {
  errors: PropTypes.object,
  formFill: PropTypes.object.isRequired,
  formField: PropTypes.object.isRequired,
  onChange: PropTypes.func.isRequired
};

FormField.defaultProps = {
  errors: {}
};
