var Index = require('./Index');

var CLASS_ROOT = "users";

var Accounts = React.createClass({

  propTypes: {
    users: React.PropTypes.array.isRequired,
    count: React.PropTypes.number.isRequired,
    filter: React.PropTypes.object
  },

  _renderUser: function (user) {
    return [
      <a className={CLASS_ROOT + "__email"} href={user.url}>{user.email}</a>,
      <span className={CLASS_ROOT + "__first-name"}>{user.firstName}</span>,
      <span className={CLASS_ROOT + "__last-name"}>{user.lastName}</span>
    ];
  },

  render: function () {
    return (
      <Index title="Accounts" itemRenderer={this._renderUser}
        responseProperty="users" items={this.props.users}
        count={this.props.count} filter={this.props.filter} />
    );
  }
});

module.exports = Accounts;
