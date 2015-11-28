var formUtils = require('./formUtils');

CLASS_ROOT = "form";

var FormFieldOption = React.createClass({

  propTypes: {
    filledForm: React.PropTypes.object.isRequired,
    formField: React.PropTypes.object.isRequired,
    formFieldOption: React.PropTypes.object.isRequired,
    onChange: React.PropTypes.func.isRequired
  },

  _onToggle: function () {
    var filledForm = this.props.filledForm;
    var formField = this.props.formField;
    var formFieldOption = this.props.formFieldOption;
    var filledField = formUtils.findFilledField(filledForm, formField.id);
    var filledFieldOption = formUtils.filledOptionForFormOption(filledForm,
      formField, formFieldOption);

    if (! filledField) {
      filledField = {
        formFieldId: formField.id,
        filledFieldOptions: []
      };
      filledForm.filledFields.push(filledField);
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
        filledField.filledFieldOptions.filter(function (option) {
          return (option.formFieldOptionId !== formFieldOption.id);
        });
      if (filledField.filledFieldOptions.length === 0) {
        filledForm.filledFields = filledForm.filledFields.filter(function (field) {
          return (formField.id !== field.formFieldId);
        });
      }
    }
    this.props.onChange(filledForm);
  },

  render: function () {
    var formField = this.props.formField;
    var formFieldOption = this.props.formFieldOption;
    var filledFieldOption = formUtils.filledOptionForFormOption(
      this.props.filledForm, formField, formFieldOption);

    var classes = [CLASS_ROOT + "__field-option"];
    var checked = filledFieldOption ? true : false;
    if (checked) {
      classes.push(CLASS_ROOT + "__field-option--active");
    }

    var type;
    var name;
    if ('single choice' === formField.fieldType) {
      type = "radio";
      name = formField.name;
    } else if ('multiple choice' === formField.fieldType) {
      type = "checkbox";
      name = formField.name + "[]";
    }

    var value;
    if (formFieldOption.value) {
      var prefix = formField.monetary ? '$' : '';
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
});

module.exports = FormFieldOption;
