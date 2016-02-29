import React, { Component, PropTypes } from 'react';
import Index from './Index';

const CLASS_ROOT = "forms";

export default class Payments extends Component {

  _renderPayment (form) {
    return (
      <a className={CLASS_ROOT + "__form-name"}
        href={form.formFillsUrl}>
        {form.name}
      </a>
    );
  }

  render () {
    return (
      <Index title="Payments" itemRenderer={this._renderPayment}
        category="payments" index={{
          items: this.props.payments,
          count: this.props.count,
          filter: this.props.filter
        }}
        newUrl={this.props.newUrl} />
    );
  }
};

// match app/views/payments/_index.json.jbuilder
Payments.propTypes = {
  newUrl: PropTypes.string,
  payments: PropTypes.array,
  count: PropTypes.number,
  filter: PropTypes.object
};
