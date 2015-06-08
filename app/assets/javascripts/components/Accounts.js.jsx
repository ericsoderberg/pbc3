var SearchInput = require('./SearchInput');
var REST = require('./REST');
var SpinnerIcon = require('./SpinnerIcon');
var Router = require('./Router');

var CLASS_ROOT = "users";

var Accounts = React.createClass({

  propTypes: {
    users: React.PropTypes.array.isRequired,
    count: React.PropTypes.number.isRequired,
    filter: React.PropTypes.object
  },

  _onChangeSearch: function (search) {
    var path = '?';
    if (search) {
      path += 'search=' + encodeURIComponent(search);
    }
    Router.replace(path);
    this.setState({
      changing: true
    });
    REST.get(path, function (response) {
      this.setState({
        users: response.users,
        filter: response.filter,
        count: response.count,
        changing: false
      });
    }.bind(this));
  },

  _onScroll: function (event) {
    var bodyRect = document.body.getBoundingClientRect();
    if (bodyRect.bottom < (window.innerHeight + 100) && this.state.users.length < this.state.count) {
      clearTimeout(this._scrollTimer);
      this._scrollTimer = setTimeout(function () {
        // get the next page's worth
        var path = '?offset=' + this.state.users.length;
        if (this.state.filter.search) {
          path += '&search=' + encodeURIComponent(this.state.filter.search);
        }
        REST.get(path, function (response) {
          var users = this.state.users.concat(response.users);
          this.setState({
            users: users,
          });
        }.bind(this));
      }.bind(this), 200);
    }
  },

  getInitialState: function () {
    return {
      users: this.props.users || [],
      count: this.props.count,
      filter: this.props.filter,
      changing: false
    };
  },

  componentDidMount: function () {
    window.addEventListener('scroll', this._onScroll);
    this._onScroll(); // in case the window is already big
  },

  componentWillUnmount: function () {
    window.removeEventListener('scroll', this._onScroll);
  },

  render: function () {
    var classes = [CLASS_ROOT];
    if (this.state.changing) {
      classes.push(CLASS_ROOT + "--changing");
    }

    var users = this.state.users.map(function (user) {
      var classes = [CLASS_ROOT + "__user"];
      return (
        <li key={user.id} className={classes.join(' ')}>
          <a className={CLASS_ROOT + "__user-email"} href={user.url}>{user.email}</a>
          <span className={CLASS_ROOT + "__user-first-name"}>{user.firstName}</span>
          <span className={CLASS_ROOT + "__user-last-name"}>{user.lastName}</span>
        </li>
      );
    });

    var noMatches = '';
    if (0 === this.state.count) {
      noMatches = (<div className={CLASS_ROOT + "__no-matches"}>No matches</div>);
    }

    var spinner = '';
    if (this.state.users.length < this.state.count) {
      spinner = (<div className={CLASS_ROOT + "__spinner spinner"}></div>);
    }

    return (
      <div className={classes.join(' ')}>
        <header className={CLASS_ROOT + "__header"}>
          <h1 className={CLASS_ROOT + "__title"}>Accounts</h1>
          <SearchInput className={CLASS_ROOT + "__search"}
            text={this.state.filter.search}
            placeholder="Search: Email, Name"
            suggestionsPath={'/accounts/suggestions?q='}
            onChange={this._onChangeSearch} />
          <span className={CLASS_ROOT + "__count"}>{this.state.count}</span>
        </header>
        {noMatches}
        <ol className={CLASS_ROOT + "__messages list-bare"}>
          {users}
        </ol>
        {spinner}
      </div>
    );
  }
});

module.exports = Accounts;
