import React, { Component, PropTypes } from 'react';
import Index from './Index';
import IndexItem from './IndexItem';

export default class Forms extends Component {

  _renderForm (form) {
    return (
      <IndexItem key={form.id} path={form.formFillsPath}>
        {form.name}
      </IndexItem>
    );
  }

  render () {
    return (
      <Index title="Forms" itemRenderer={this._renderForm}
        category="forms" index={{
          items: this.props.forms,
          count: this.props.count,
          filter: this.props.filter
        }}
        newUrl={this.props.newUrl} />
    );
  }
};

// match app/views/forms/_index.json.jbuilder
Forms.propTypes = {
  newUrl: PropTypes.string,
  forms: PropTypes.array,
  count: PropTypes.number,
  filter: PropTypes.object
};
