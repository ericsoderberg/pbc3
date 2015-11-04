var REST = require('./REST');

CLASS_ROOT = "form";

var Option = React.createClass({

  propTypes: {
    field: React.PropTypes.object.isRequired,
    option: React.PropTypes.object.isRequired,
    onChange: React.PropTypes.func.isRequired
  },

  _onToggle: function () {
    var option = this.props.option;
    if (! option.hasOwnProperty('filledFieldOption')) {
      option.filledFieldOption = {value: option.formFieldOption.name};
    } else {
      delete option.filledFieldOption;
    }
    this.props.onChange(option);
  },

  render: function () {
    var formField = this.props.field.formField;
    var formFieldOption = this.props.option.formFieldOption;
    var filledFieldOption = this.props.option.filledFieldOption;
    var checked = filledFieldOption ? true : false;
    var type;
    var name;
    if ('single choice' === formField.fieldType) {
      type = "radio";
      name = formField.name;
    } else if ('multiple choice' === formField.fieldType) {
      type = "checkbox";
      name = formField.name + "[]";
    }
    return (
      <div key={formFieldOption.id} className={CLASS_ROOT + "__field-option"}>
        <input type={type} name={name} checked={checked}
          onChange={this._onToggle} />
        {formFieldOption.name}
        <span className="form__field-option-help">
          {formFieldOption.help}
        </span>
      </div>
    );
  }
});

var Field = React.createClass({

  propTypes: {
    field: React.PropTypes.object.isRequired,
    onChange: React.PropTypes.func.isRequired
  },

  _onChange: function (event) {
    var field = this.props.field;
    if (! field.hasOwnProperty('filledField')) {
      field.filledField = {};
    }
    field.filledField.value = event.target.value;
    this.props.onChange(field);
  },

  _onOptionChange: function (option) {
    var field = this.props.field;
    field.options = field.options.map(function (option2) {
      var result;
      if ('single choice' === field.formField.fieldType) {
        // turn off all other options
        if (option.formFieldOption.id === option2.formFieldOption.id) {
          result = option;
        } else {
          result = {formFieldOption: option2.formFieldOption};
        }
      } else {
        result = (option.formFieldOption.id === option2.formFieldOption.id ?
          option : option2);
      }
      return result;
    });
    this.props.onChange(field);
  },

  render: function () {
    var field = this.props.field;
    var formField = field.formField;
    var filledField = field.filledField;

    var result;

    if ('instructions' === formField.fieldType) {

      result = (
        <div className={CLASS_ROOT + "__field form__fields_help"}>
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

      var content;
      var value = filledField ? filledField.value : formField.value;
      if ('single line' === formField.fieldType) {
        content = (
          <input ref="input" type="text" name={formField.name} value={value}
            onChange={this._onChange} />
        );
      } else if ('multiple lines' === formField.fieldType) {
        content = (
          <textarea ref="input" name={formField.name} value={value}
            onChange={this._onChange} />
        );
      } else if ('single choice' === formField.fieldType) {
        content = field.options.map(function (option) {
          return (
            <Option key={option.formFieldOption.id}
              field={field} option={option}
              onChange={this._onOptionChange} />
          );
        }, this);
      } else if ('multiple choice' === formField.fieldType) {
        content = field.options.map(function (option) {
          return (
            <Option key={option.formFieldOption.id}
              field={field} option={option}
              onChange={this._onOptionChange} />
          );
        }, this);
      } else if ('count' === formField.fieldType) {
        content = (
          <input ref="input" type="number" name={formField.name} value={value}
            onChange={this._onChange} />
        );
      }

      result = (
        <div className={CLASS_ROOT + "__field"}>
          {label}
          {help}
          {content}
        </div>
      );
    }

    return result;
  }
});

var Section = React.createClass({

  propTypes: {
    onChange: React.PropTypes.func.isRequired,
    section: React.PropTypes.object.isRequired
  },

  _onFieldChange: function (field) {
    var section = this.props.section;
    section.fields = section.fields.map(function (field2) {
      return (field.formField.id === field2.formField.id ? field : field2);
    });
    this.props.onChange(section);
  },

  render: function () {
    var section = this.props.section;

    var fields = section.fields.map(function (field, index) {
      return (
        <Field key={field.formField.id} field={field}
          onChange={this._onFieldChange} />
      );
    }, this);

    return (
      <fieldset className={CLASS_ROOT + "__section"}>
        <legend className={CLASS_ROOT + "__section-header"}>
          <h2>{section.name}</h2>
        </legend>
        <div className="form__fields">
          {fields}
        </div>
      </fieldset>
    );
  }
});


var Form = React.createClass({

  propTypes: {
    authenticityToken: React.PropTypes.string,
    createUrl: React.PropTypes.string,
    form: React.PropTypes.object.isRequired,
    tag: React.PropTypes.string,
    updateUrl: React.PropTypes.string,
  },

  getDefaultProps: function () {
    return {tag: 'form'};
  },

  getInitialState: function () {
    return {form: this.props.form};
  },

  _filledFields: function () {
    var filledFields = {};
    this.state.form.formSections.forEach(function (formSection) {
      formSection.fields.forEach(function (field) {
        if (field.hasOwnProperty('options')) {
          var filledOptions = field.options.filter(function (option) {
            return option.hasOwnProperty('filledFieldOption');
          });
          if (filledOptions.length > 0) {
            if ('single choice' === field.formField.fieldType) {
              filledFields[field.formField.id] =
                filledOptions[0].formFieldOption.id;
            } else if ('multiple choice' === field.formField.fieldType) {
              filledFields[field.formField.id] =
                filledOptions.map(function (option) {
                  return (option.formFieldOption.id);
                });
            }
          }
        } else if (field.hasOwnProperty('filledField')) {
          filledFields[field.formField.id] = field.filledField.value;
        }
      });
    });
    return filledFields;
  },

  _onSubmit: function (event) {
    event.preventDefault();
    var url;
    var action;
    if (this.props.createUrl) {
      url = this.props.createUrl;
      action = 'post';
    } else if (this.props.updateUrl) {
      url = this.props.updateUrl;
      action = 'put';
    }
    if (action) {
      var token = this.props.authenticityToken;
      var filledFields = this._filledFields();
      console.log('!!! Form _onSubmit', token, filledFields);
      REST[action](url, token,
        {filledFields: filledFields, email_address_confirmation: ''},
        function (response) {
          console.log('!!! Form _onSubmit completed', response);
          if (response.result === 'ok') {
            ///location = response.redirect_to;
          }
        }.bind(this));
    }
  },

  _onSectionChange: function (section) {
    var form = this.state.form;
    form.formSections = form.formSections.map(function (formSection) {
      return (section.id === formSection.id ? section : formSection);
    });
    this.setState({form: form});
  },

  render: function() {
    var form = this.props.form;

    var sections = form.formSections.map(function (formSection, index) {
      return (
        <Section key={formSection.id} section={formSection}
          onChange={this._onSectionChange} />
      );
    }, this);

    return (
      <this.props.tag className={CLASS_ROOT}>
        <div className={CLASS_ROOT + "__header"}>
          {form.name}
        </div>

        <div className={CLASS_ROOT + "__contents"}>
          <input name="email_address_confirmation" value=""
            id="email_address_confirmation" placeholder="email address" />
          <div className={CLASS_ROOT + "__sections"}>
            {sections}
          </div>
        </div>

        <div className={CLASS_ROOT + "__footer"}>
          <input type="submit" value={form.submitLabel || 'Submit'}
            className="btn btn--primary"
            onClick={this._onSubmit} />
        </div>
      </this.props.tag>
    );
  }
});

module.exports = Form;
