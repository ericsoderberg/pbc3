import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import moment from 'moment';
import Index from './Index';
import IndexItem from './IndexItem';

class FormFills extends Component {

  _renderFormFill (formFill) {
    var date = moment(formFill.updatedAt);
    return (
      <IndexItem key={formFill.id} path={formFill.editPath}>
        {formFill.name}
        <span key="date">{date.format('MMM D, YYYY')}</span>
      </IndexItem>
    );
  }

  render () {
    return (
      <Index title={this.props.form.name || 'Form'}
        itemRenderer={this._renderFormFill}
        category="formFills" context="form" index={{
          items: this.props.formFills,
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
FormFills.propTypes = {
  count: PropTypes.number,
  editUrl: PropTypes.string,
  formFills: PropTypes.array,
  filter: PropTypes.object,
  form: PropTypes.object,
  newPath: PropTypes.string,
  page: PropTypes.object
};

let select = (state) => ({form: state.index.context});

export default connect(select)(FormFills);
