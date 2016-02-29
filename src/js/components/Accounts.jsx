import React, { Component, PropTypes } from 'react';
import Index from './Index';

const CLASS_ROOT = "users";

export default class Accounts extends Component {

  _renderUser (user) {
    return [
      <a key="email" className={CLASS_ROOT + "__email"} href={user.url}>
        {user.email}
      </a>,
      <span key="first" className={CLASS_ROOT + "__first-name"}>
        {user.firstName}
      </span>,
      <span key="last" className={CLASS_ROOT + "__last-name"}>
        {user.lastName}
      </span>
    ];
  }

  render () {
    return (
      <Index title="Accounts" itemRenderer={this._renderUser}
        category="users" index={{
          items: this.props.users,
          count: this.props.count,
          filter: this.props.filter
        }} />
    );
  }
};

Accounts.propTypes = {
  users: PropTypes.array,
  count: PropTypes.number,
  filter: PropTypes.object
};
