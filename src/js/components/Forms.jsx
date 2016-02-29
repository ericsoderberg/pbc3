import React, { Component, PropTypes } from 'react';
import { Link } from 'react-router';
import Index from './Index';

const CLASS_ROOT = "forms";

export default class Forms extends Component {

  _renderForm (form) {
    return (
      <Link className={`${CLASS_ROOT}__form-name`}
        to={form.formFillsPath}>
        {form.name}
      </Link>
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
