import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import moment from 'moment';
import Index from './Index';

const CLASS_ROOT = "filled-forms";

class FilledForms extends Component {

  constructor () {
    super();
    this._renderFilledForm = this._renderFilledForm.bind(this);
  }

  _renderFilledForm (filledForm) {
    var date = moment(filledForm.updatedAt);
    var parts = [
      <Link key="name" className={`${CLASS_ROOT}__form-name`}
        to={filledForm.editPath}>
        {filledForm.name}
      </Link>,
      <span key="date">{date.format('MMM D, YYYY')}</span>
    ];
    if (this.props.form.version > 1) {
      parts.push(<span>{filledForm.version}</span>);
    }
    return parts;
  }

  render () {
    return (
      <Index title={this.props.form.name || 'Form'}
        itemRenderer={this._renderFilledForm}
        category="filledForms" context="form" index={{
          items: this.props.filledForms,
          count: this.props.count,
          filter: this.props.filter
        }}
        noneMessage="Nobody has filled out this form yet"
        newPath={this.props.newPath} editUrl={this.props.editUrl}
        page={this.props.page} />
    );
  }
};

// match app/views/filled_forms/_index.json.jbuilder
FilledForms.propTypes = {
  count: PropTypes.number,
  editUrl: PropTypes.string,
  filledForms: PropTypes.array,
  filter: PropTypes.object,
  form: PropTypes.object,
  newPath: PropTypes.string,
  page: PropTypes.object
};

let select = (state) => ({form: state.index.context});

export default connect(select)(FilledForms);
