import React, { Component, PropTypes } from 'react';
import FormFieldOption from './FormFieldOption';
import formUtils from './formUtils';

const CLASS_ROOT = "form";

export default class FormField extends Component {

  _onChange (event) {
    var value = event.target.value;
    var filledForm = this.props.filledForm;
    var formField = this.props.formField;
    var filledField = formUtils.findFilledField(filledForm, formField.id);
    if (value) {
      if (! filledField) {
        filledField = {formFieldId: formField.id};
        filledForm.filledFields.push(filledField);
      }
      filledField.value = value;
    } else {
      filledForm.filledFields = filledForm.filledFields.filter(function (field) {
        return (formField.id !== field.formFieldId);
      });
    }
    this.props.onChange(filledForm);
  }

  render () {
    var formField = this.props.formField;
    var filledField =
      formUtils.findFilledField(this.props.filledForm, formField.id);
    var hidden = false;
    if (formField.dependsOnId) {
      var dependsOn =
        formUtils.findFilledField(this.props.filledForm, formField.dependsOnId);
      if (! dependsOn) {
        hidden = true;
      }
    }

    var result;

    if (hidden) {
      result = <span></span>;
    } else if ('instructions' === formField.fieldType) {

      result = (
        <div className={`${CLASS_ROOT}__field form__fields-help`}>
          {formField.help}
        </div>
      );

    } else {

      var label;
      if (formField.name) {
        label = <label>{formField.name}</label>;
      }

      var help;
      if (formField.help) {
        help = <div className="form__field-help">{formField.help}</div>;
      }
      var error;
      if (this.props.fieldErrors.hasOwnProperty(formField.name)) {
        error = (
          <div className="form__field-error">
            {this.props.fieldErrors[formField.name]}
          </div>
        );
      }

      var content;
      var value = filledField ? filledField.value : formField.value;
      if ('single line' === formField.fieldType) {
        content = (
          <input ref="input" type="text" name={formField.name} value={value}
            onChange={this._onChange} />
        );
        if (formField.monetary) {
          content = (
            <div className="form__field-decorated-input">
              <span className="form__field-decorated-input-prefix">$</span>
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
        content = formField.formFieldOptions.map(function (formFieldOption) {
          return (
            <FormFieldOption key={formFieldOption.id}
              formField={formField}
              formFieldOption={formFieldOption}
              filledForm={this.props.filledForm}
              onChange={this.props.onChange} />
          );
        }, this);
      } else if ('count' === formField.fieldType) {
        var suffix = 'x ' + (formField.monetary ? '$' : '') + formField.unitValue;
        if (value) {
          suffix += ' = ' + (formField.monetary ? '$' : '') +
            (formField.unitValue * value);
        }
        content = (
          <div className="form__field-decorated-input">
            <input ref="input" type="number" name={formField.name}
              value={value} onChange={this._onChange} />
            <span className="form__field-decorated-input-suffix">{suffix}</span>
          </div>
        );
      }

      result = (
        <div className={`${CLASS_ROOT}__field`}>
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
  fieldErrors: PropTypes.object,
  filledForm: PropTypes.object.isRequired,
  formField: PropTypes.object.isRequired,
  onChange: PropTypes.func.isRequired
};
