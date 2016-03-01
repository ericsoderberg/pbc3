import React, { Component, PropTypes } from 'react';
import REST from '../REST';
import moment from 'moment';
import CloseIcon from '../icons/CloseIcon';
import FormSection from './FormSection';
import formUtils from './formUtils';

const CLASS_ROOT = "form";

function filledFieldsForForm (form, filledForm) {
  let result = {};
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

export default class Form extends Component {

  constructor (props) {
    super(props);

    let mode;
    let filledForm;

    if (props.form.mode) {
      mode = props.form.mode;
    } else if (props.form.filledForms.length === 0 || 'form' !== props.tag) {
      mode = 'new';
    } else {
      mode = 'show';
    }
    if ('new' === mode) {
      filledForm = {filledFields: []};
    } else if ('edit' === mode) {
      filledForm = props.form.filledForms[0];
    }

    this.state = {
      filledForm: filledForm,
      filledForms: props.form.filledForms,
      mode: mode,
      fieldErrors: {}
    };
  }

  _onSubmit (event) {
    event.preventDefault();
    const filledForm = this.state.filledForm;
    const filledFields = filledFieldsForForm(this.props.form.form, filledForm);
    let url;
    let action;
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
    const token = this.props.form.authenticityToken;
    REST[action](url, token, data,
      function (response) {
        // Successful submit
        if (response.redirectUrl) {
          // not in a page
          window.location = response.redirectUrl;
        } else {
          // in a page
          let filledForm = response;
          let filledForms;
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
  }

  _onDelete (filledForm) {
    const token = this.props.form.authenticityToken;
    REST.delete(filledForm.url, token, function (response) {
      if (response.result === 'ok') {
        const filledForms = this.state.filledForms.filter(function (filled) {
          return (filled.id !== filledForm.id);
        });
        let mode = this.state.mode;
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
  }

  _onEdit (filledForm) {
    this.setState({mode: 'edit', filledForm: filledForm});
  }

  _onChange (filledForm) {
    this.setState({filledForm: filledForm});
  }

  _onCancel (event) {
    this.setState({mode: 'show', filledForm: null});
  }

  _onAdd (event) {
    event.preventDefault();
    this.setState({mode: 'new', filledForm: {filledFields: []}});
  }

  _renderEdit () {
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
      remove = (<a onClick={function (event) {
        event.preventDefault();
        if (window.confirm('Are you sure?')) {
          this._onDelete(this.state.filledForm);
        }
      }.bind(this)}>Remove</a>);
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
  }

  _renderSummary (form, filledForm) {
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
      summary += ' ' + updatedAt.fromNow();
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
  }

  _renderShow () {
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
      );
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
      all = (<a className={classRoot + '__all'}
        href={this.props.form.indexUrl}>all</a>);
    }

    return (
      <div className={classRoot}>
        <div className={classRoot + "__header"}>{form.name}</div>
        <table>{filledForms}</table>
        {add}
        {all}
      </div>
    );
  }

  render () {
    var result;
    if ('new' === this.state.mode || 'edit' === this.state.mode) {
      result = this._renderEdit();
    } else {
      result = this._renderShow();
    }
    return result;
  }
};

Form.propTypes = {
  authenticityToken: PropTypes.string,
  createUrl: PropTypes.string,
  filled_forms: PropTypes.array,
  form: PropTypes.object.isRequired,
  mode: PropTypes.string,
  tag: PropTypes.string
};

Form.defaultProps = {
  tag: 'form'
};
