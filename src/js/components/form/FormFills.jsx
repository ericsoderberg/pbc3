import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { loadForm, updateForm, unloadForm } from '../../actions/actions';
import moment from 'moment';

const CLASS_ROOT = "form-fills";

export default class FormFills extends Component {

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

  _onEdit (filledForm) {
    this.setState({mode: 'edit', filledForm: filledForm});
  }

  _onAdd (event) {
    event.preventDefault();
    this.setState({mode: 'new', filledForm: {filledFields: []}});
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

  render () {
    var form = this.props.form.form;

    var filledForms = this.state.filledForms.map(filledForm => {
      var summary = this._renderSummary(form, filledForm);
      return (
        <tr key={filledForm.id} className={`${CLASS_ROOT}__fill`}>
          <td className={`${CLASS_ROOT}__date`}>{summary}</td>
          <td>
            <a onClick={(event) => {
              event.preventDefault();
              this._onEdit(filledForm);
            }}>Update</a>
          </td>
        </tr>
      );
    });

    var add;
    if (form.manyPerUser) {
      add = (
        <a onClick={this._onAdd} className={`${CLASS_ROOT}__add`}>
          Add another
        </a>
      );
    }
    var all;
    if (this.props.form.indexUrl) {
      all = (<a className={`${CLASS_ROOT}__all`}
        href={this.props.form.indexUrl}>all</a>);
    }

    return (
      <div className={classRoot}>
        <div className={`${CLASS_ROOT}__header`}>{form.name}</div>
        <table>{filledForms}</table>
        {add}
        {all}
      </div>
    );
  }
};

FormFills.propTypes = {
  authenticityToken: PropTypes.string,
  createUrl: PropTypes.string,
  filled_forms: PropTypes.array,
  form: PropTypes.object.isRequired,
  mode: PropTypes.string,
  tag: PropTypes.string
};

FormFills.defaultProps = {
  tag: 'form'
};
