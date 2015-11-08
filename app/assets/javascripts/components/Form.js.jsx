var REST = require('./REST');
var moment = require('moment');
var CloseIcon = require('./CloseIcon');

CLASS_ROOT = "form";

function formFieldForFilledField (form, filledField) {
  var result;
  form.formSections.some(function (formSection) {
    return formSection.formFields.some(function (formField) {
      if (formField.id === filledField.formFieldId) {
        result = formField;
        return true;
      }
    });
  });
  return result;
}

function filledFieldForFormField (filledForm, formField) {
  var result;
  filledForm.filledFields.some(function (filledField) {
    if (formField.id === filledField.formFieldId) {
      result = filledField;
      return true;
    }
  });
  return result;
}

function filledOptionForFormOption (filledForm, formField, formFieldOption) {
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
}

function filledFieldsForForm (form, filledForm) {
  var result = {};
  filledForm.filledFields.forEach(function (filledField) {
    var formField = formFieldForFilledField(form, filledField);
    if ('single choice' === formField.fieldType) {
      if (filledField.filledFieldOptions.length > 0) {
        result[formField.id] =
          filledField.filledFieldOptions[0].formFieldOptionId;
      }
    } else if ('multiple choice' === formField.fieldType) {
      if (filledField.filledFieldOptions.length > 0) {
        result[formField.id] =
          filledField.filledFieldOptions.map(function (filledFieldOption) {
            return (filledFieldOption.formFieldOptionId);
          });
      }
    } else {
      result[formField.id] = filledField.value;
    }
  });
  return result;
}

var Option = React.createClass({

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
    var filledField = filledFieldForFormField(filledForm, formField);
    var filledFieldOption =
      filledOptionForFormOption(filledForm, formField, formFieldOption);

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
    }
    this.props.onChange(filledForm);
  },

  render: function () {
    var formField = this.props.formField;
    var formFieldOption = this.props.formFieldOption;
    var filledFieldOption =
      filledOptionForFormOption(this.props.filledForm, formField, formFieldOption);
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
    filledForm: React.PropTypes.object.isRequired,
    formField: React.PropTypes.object.isRequired,
    onChange: React.PropTypes.func.isRequired
  },

  _onChange: function (event) {
    var filledForm = this.props.filledForm;
    var formField = this.props.formField;
    var filledField = filledFieldForFormField(filledForm, formField);
    if (! filledField) {
      filledField = {formFieldId: formField.id}
      filledForm.filledFields.push(filledField);
    }
    filledField.value = event.target.value;
    this.props.onChange(filledForm);
  },

  render: function () {
    var formField = this.props.formField;
    var filledField = filledFieldForFormField(this.props.filledForm, formField);

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
        content = formField.formFieldOptions.map(function (formFieldOption) {
          return (
            <Option key={formFieldOption.id}
              formField={formField} formFieldOption={formFieldOption}
              filledForm={this.props.filledForm}
              onChange={this.props.onChange} />
          );
        }, this);
      } else if ('multiple choice' === formField.fieldType) {
        content = formField.formFieldOptions.map(function (formFieldOption) {
          return (
            <Option key={formFieldOption.id}
              formField={formField} formFieldOption={formFieldOption}
              filledForm={this.props.filledForm}
              onChange={this.props.onChange} />
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
    filledForm: React.PropTypes.object.isRequired,
    onChange: React.PropTypes.func.isRequired,
    formSection: React.PropTypes.object.isRequired
  },

  _onChange: function (filledForm) {
    this.props.onChange(filledForm);
  },

  render: function () {
    var formSection = this.props.formSection;

    var fields = formSection.formFields.map(function (formField) {
      return (
        <Field key={formField.id}
          formField={formField}
          filledForm={this.props.filledForm}
          onChange={this._onChange} />
      );
    }, this);

    return (
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
});


var Form = React.createClass({

  propTypes: {
    form: React.PropTypes.object.isRequired,
    mode: React.PropTypes.string,
    tag: React.PropTypes.string
  },

  getDefaultProps: function () {
    return {tag: 'form'};
  },

  getInitialState: function () {
    var mode;
    var filledForm;

    if (this.props.form.mode) {
      mode = this.props.form.mode;
    } else if (this.props.form.filledForms.length === 0 || 'form' !== this.props.tag) {
      mode = 'new';
    } else {
      mode = 'show';
    }
    if ('new' === mode) {
      filledForm = {filledFields: []};
    } else if ('edit' === mode) {
      filledForm = this.props.form.filledForms[0];
    }

    return {
      filledForm: filledForm,
      filledForms: this.props.form.filledForms,
      mode: mode
    };
  },

  _onSubmit: function (event) {
    event.preventDefault();
    var filledForm = this.state.filledForm;
    var filledFields = filledFieldsForForm(this.props.form.form, filledForm)
    var url;
    var action;
    if ('new' === this.state.mode) {
      url = this.props.form.createUrl;
      action = 'post';
    } else {
      url = this.state.filledForm.url;
      action = 'put';
    }
    var token = this.props.form.authenticityToken;
    REST[action](url, token,
      {filledFields: filledFields, email_address_confirmation: ''},
      function (response) {
        if (response.id) {
          filledForm = response;
          var filledForms
          if ('new' === this.state.mode) {
            filledForms = this.state.filledForms;
            filledForms.push(filledForm);
          } else {
            filledForms = this.state.filledForms.map(function (filledForm2) {
              return (filledForm2.id === filledForm.id ? filledForm : filledForm2);
            });
          }
          this.setState({mode: 'show', filledForm: null, filledForms: filledForms});
        }
      }.bind(this));
  },

  _onDelete: function (filledForm) {
    var token = this.props.form.authenticityToken;
    REST.delete(filledForm.url, token, function (response) {
      if (response.result === 'ok') {
        var filledForms = this.state.filledForms.filter(function (filled) {
          return (filled.id !== filledForm.id);
        });
        var mode = this.state.mode;
        filledForm = null;
        if (filledForms.length === 0) {
          mode = 'new';
          filledForm = {filledFields: []};
        } else {
          mode = 'show';
        }
        this.setState({filledForms: filledForms,
          mode: mode, filledForm: filledForm});
      }
    }.bind(this));
  },

  _onEdit: function (filledForm) {
    this.setState({mode: 'edit', filledForm: filledForm});
  },

  _onChange: function (filledForm) {
    this.setState({filledForm: filledForm});
  },

  _onCancel: function (event) {
    this.setState({mode: 'show', filledForm: null});
  },

  _onAdd: function (event) {
    event.preventDefault();
    this.setState({mode: 'new', filledForm: {filledFields: []}});
  },

  _renderEdit: function () {
    var form = this.props.form.form;

    var sections = form.formSections.map(function (formSection, index) {
      return (
        <Section key={formSection.id}
          formSection={formSection}
          filledForm={this.state.filledForm}
          onChange={this._onChange} />
      );
    }, this);

    var remove;
    var cancel;
    var headerCancel;
    if ('edit' === this.state.mode) {
      cancel = <a onClick={this._onCancel}>Cancel</a>;
      remove = <a onClick={function (event) {
        event.preventDefault();
        if (window.confirm('Are you sure?')) {
          this._onDelete(this.state.filledForm);
        }
      }.bind(this)}>Remove</a>;
      if ('edit' === this.props.form.mode) {
        headerCancel = (
          <a className="control-icon" href={this.props.form.indexUrl}>
            <CloseIcon />
          </a>
        );
        cancel = null;
      }
    } else if (form.manyPerUser && this.state.filledForms.length > 0) {
      cancel = <a onClick={this._onCancel}>Cancel</a>;
    }

    return (
      <this.props.tag className={CLASS_ROOT}>
        <div className={CLASS_ROOT + "__header"}>
          <span className="form__title">{form.name}</span>
          {headerCancel}
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
          {remove}
          {cancel}
        </div>
      </this.props.tag>
    );
  },

  _renderSummary: function (form, filledForm) {
    var createdAt = moment(filledForm.createdAt);
    var updatedAt = moment(filledForm.updatedAt);
    var now = moment();
    var summary;

    if (updatedAt.isBefore(now, 'minute')) {
      if (createdAt.isBefore(updatedAt)) {
        summary = 'Updated';
      } else {
        summary = 'Submitted';
        if (form.manyPerUser) {
          summary += ' for';
        }
      }
      if (form.manyPerUser) {
        summary += ' ' + filledForm.name;
      }
      summary += ' ' + updatedAt.fromNow()
    } else {
      summary = 'Thanks for';
      if (createdAt.isBefore(updatedAt)) {
        summary += ' the update';
      } else {
        summary += ' your submittal';
      }
      if (form.manyPerUser) {
        summary += ' for ' + filledForm.name;
      }
    }
    summary += '.';
    return summary;
  },

  _renderShow: function () {
    var form = this.props.form.form;
    var classRoot = CLASS_ROOT + '-fills';

    var filledForms = this.state.filledForms.map(function (filledForm) {
      var summary = this._renderSummary(form, filledForm);
      return (
        <tr key={filledForm.id} className={classRoot + '__fill'}>
          <td className={classRoot + '__date'}>{summary}</td>
          <td>
            <button onClick={function (event) {
              event.preventDefault();
              this._onEdit(filledForm);
            }.bind(this)}>Update</button>
          </td>
        </tr>
      )
    }, this);

    var add;
    if (form.manyPerUser) {
      add = (
        <button onClick={this._onAdd} className={classRoot + '__add'}>
          Add another
        </button>
      );
    }
    var list;
    if (this.props.form.indexUrl) {
      list = <a href={this.props.form.indexUrl}>list</a>;
    }

    return (
      <div className={classRoot}>
        <div className={classRoot + "__header"}>{form.name}</div>
        <table>{filledForms}</table>
        {add}
        {list}
      </div>
    );
  },

  render: function () {
    var result;
    if ('new' === this.state.mode || 'edit' === this.state.mode) {
      result = this._renderEdit();
    } else {
      result = this._renderShow();
    }
    return result;
  }
});

module.exports = Form;
