import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
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
      <a key="name" className={`${CLASS_ROOT}__form-name`}
        href={filledForm.editUrl}>
        {filledForm.name}
      </a>,
      <span key="date">{date.format('MMM D, YYYY')}</span>
    ];
    if (this.props.form.version > 1) {
      parts.push(<span>{filledForm.version}</span>);
    }
    return parts;
  }

  render () {
    return (
      <Index title={this.props.form.name || 'Form'} itemRenderer={this._renderFilledForm}
        category="filledForms" context="form" index={{
          items: this.props.filledForms,
          count: this.props.count,
          filter: this.props.filter
        }}
        noneMessage="Nobody has filled out this form yet"
        newUrl={this.props.newUrl} editUrl={this.props.editUrl}
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
  newUrl: PropTypes.string,
  page: PropTypes.object
};

let select = (state) => ({form: state.index.context});

export default connect(select)(FilledForms);
