import React, { Component, PropTypes } from 'react';
import { Link } from 'react-router';
// import { connect } from 'react-redux';
// import { loadForm, updateForm, unloadForm } from '../../actions/actions';
import moment from 'moment';

const CLASS_ROOT = "form-fills";

export default class UserFormFills extends Component {

  _renderState (form, formFill) {
    const createdAt = moment(formFill.createdAt);
    const updatedAt = moment(formFill.updatedAt);
    const now = moment();
    let state;

    if (updatedAt.isBefore(now, 'minute')) {
      if (createdAt.isBefore(updatedAt)) {
        state = 'Updated';
      } else {
        state = 'Submitted';
        if (form.manyPerUser) {
          state += ' for';
        }
      }
      if (form.manyPerUser) {
        state += ' ' + formFill.name;
      }
      state += ' ' + updatedAt.fromNow();
    } else {
      state = 'Thanks for';
      if (createdAt.isBefore(updatedAt)) {
        state += ' the update';
      } else {
        state += ' your submittal';
      }
      if (form.manyPerUser) {
        state += ' for ' + formFill.name;
      }
    }
    state += '.';
    return state;
  }

  render () {
    const { form, formFills, indexPath } = this.props;

    const fills = formFills.map(formFill => {
      const summary = this._renderState(form, formFill);
      return (
        <tr key={formFill.id} className={`${CLASS_ROOT}__fill`}>
          <td className={`${CLASS_ROOT}__date`}>{summary}</td>
          <td>
            <a onClick={(event) => {
              event.preventDefault();
              this.props.onEdit(formFill.id);
            }}>Edit</a>
          </td>
        </tr>
      );
    });

    let add;
    if (form.manyPerUser) {
      add = (
        <a className={`${CLASS_ROOT}__add`} onClick={(event) => {
          event.preventDefault();
          this.props.onAdd();
        }}>
          Add another
        </a>
      );
    }

    let all;
    if (indexPath) {
      all =  <Link className={`${CLASS_ROOT}__all`} to={indexPath}>all</Link>;
    }

    return (
      <div className={CLASS_ROOT}>
        <div className={`${CLASS_ROOT}__header`}>{form.name}</div>
        <table><tbody>{fills}</tbody></table>
        {add}
        {all}
      </div>
    );
  }
};

UserFormFills.propTypes = {
  filled_forms: PropTypes.array,
  form: PropTypes.object.isRequired,
  indexPath: PropTypes.string,
  onAdd: PropTypes.func.isRequired,
  onEdit: PropTypes.func.isRequired
};
