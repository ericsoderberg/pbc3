var FormField = require('./FormField');
var formUtils = require('./formUtils');

CLASS_ROOT = "form";

var FormSection = React.createClass({

  propTypes: {
    fieldErrors: React.PropTypes.object.isRequired,
    filledForm: React.PropTypes.object.isRequired,
    formSection: React.PropTypes.object.isRequired,
    onChange: React.PropTypes.func.isRequired
  },

  _onChange: function (filledForm) {
    this.props.onChange(filledForm);
  },

  render: function () {
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
});

module.exports = FormSection;
