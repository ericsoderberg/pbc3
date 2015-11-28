var REST = require('../REST');
var moment = require('moment');
var CloseIcon = require('../icons/CloseIcon');
var FormSection = require('./FormSection');
var formUtils = require('./formUtils');

CLASS_ROOT = "form";

function filledFieldsForForm (form, filledForm) {
  var result = {};
  filledForm.filledFields.forEach(function (filledField) {
    var formField = formUtils.findFormField(form, filledField.formFieldId);
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
      mode: mode,
      fieldErrors: {}
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
    var data = {
      filledFields: filledFields,
      email_address_confirmation: ''
    };
    if (this.props.form.pageId) {
      data.pageId = this.props.form.pageId;
    }
    var token = this.props.form.authenticityToken;
    REST[action](url, token, data,
      function (response) {
        // Successful submit
        if (response.redirectUrl) {
          // not in a page
          window.location = response.redirectUrl;
        } else {
          // in a page
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
          this.setState({
            mode: 'show',
            filledForm: null,
            filledForms: filledForms,
            fieldErrors: {}
          });
        }
      }.bind(this), function (errors) {
        this.setState({fieldErrors: errors});
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
        <FormSection key={formSection.id}
          formSection={formSection}
          filledForm={this.state.filledForm}
          fieldErrors={this.state.fieldErrors}
          onChange={this._onChange} />
      );
    }, this);

    var remove;
    var cancel;
    var headerCancel;
    if ('edit' === this.state.mode) {
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
      } else {
        headerCancel = (
          <a className="control-icon" onClick={this._onCancel}>
            <CloseIcon />
          </a>
        );
        cancel = <a onClick={this._onCancel}>Cancel</a>;
      }
    } else if ('new' === this.props.form.mode) {
      headerCancel = (
        <a className="control-icon" href={this.props.form.indexUrl}>
          <CloseIcon />
        </a>
      );
    } else if (form.manyPerUser && this.state.filledForms.length > 0) {
      headerCancel = (
        <a className="control-icon" onClick={this._onCancel}>
          <CloseIcon />
        </a>
      );
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
            <a onClick={function (event) {
              event.preventDefault();
              this._onEdit(filledForm);
            }.bind(this)}>Update</a>
          </td>
        </tr>
      )
    }, this);

    var add;
    if (form.manyPerUser) {
      add = (
        <a onClick={this._onAdd} className={classRoot + '__add'}>
          Add another
        </a>
      );
    }
    var all;
    if (this.props.form.indexUrl) {
      all = <a className={classRoot + '__all'}
        href={this.props.form.indexUrl}>all</a>;
    }

    return (
      <div className={classRoot}>
        <div className={classRoot + "__header"}>{form.name}</div>
        <table>{filledForms}</table>
        {add}
        {all}
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
