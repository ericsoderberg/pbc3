import React, { Component, PropTypes } from 'react';
import Index from './Index';
import IndexItem from './IndexItem';

export default class Accounts extends Component {

  _renderUser (user) {
    return (
      <IndexItem key={user.id} url={user.url}>
        {user.email}
        {user.firstName}
        {user.lastName}
      </IndexItem>
    );
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
