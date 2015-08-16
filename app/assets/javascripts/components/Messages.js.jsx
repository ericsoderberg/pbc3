var moment = require('moment');
var SearchInput = require('./SearchInput');
var REST = require('./REST');
var SpinnerIcon = require('./SpinnerIcon');
var AddIcon = require('./AddIcon');
var Router = require('./Router');

var CLASS_ROOT = "messages";

var Messages = React.createClass({

  propTypes: {
    messages: React.PropTypes.array.isRequired,
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
        messages: response.messages,
        filter: response.filter,
        count: response.count,
        changing: false
      });
    }.bind(this));
  },

  _onScroll: function (event) {
    var bodyRect = document.body.getBoundingClientRect();
    if (bodyRect.bottom < (window.innerHeight + 100) && this.state.messages.length < this.state.count) {
      clearTimeout(this._scrollTimer);
      this._scrollTimer = setTimeout(function () {
        // get the next page's worth
        var path = '?offset=' + this.state.messages.length;
        if (this.state.filter.search) {
          path += '&search=' + encodeURIComponent(this.state.filter.search);
        }
        REST.get(path, function (response) {
          var messages = this.state.messages.concat(response.messages);
          this.setState({
            messages: messages,
          });
        }.bind(this));
      }.bind(this), 200);
    }
  },

  getInitialState: function () {
    return {
      messages: this.props.messages || [],
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

    var year = null;
    var messages = this.state.messages.map(function (message) {
      var classes = [CLASS_ROOT + "__message"];
      var date = moment(message.date);
      if (! year || date.year() !== year) {
        classes.push(CLASS_ROOT + "__message--year");
        year = date.year();
      }
      return (
        <li key={message.id} className={classes.join(' ')}>
          <span className={CLASS_ROOT + "__message-year"}>
            {date.format('YYYY')}
          </span>
          <span className={CLASS_ROOT + "__message-date"}>
            {date.format('MMM D')}
          </span>
          <a className={CLASS_ROOT + "__message-title"} href={message.url}>
            {message.title}
          </a>
          <span className={CLASS_ROOT + "__message-verses"}>
            {message.verses}
          </span>
          <span className={CLASS_ROOT + "__message-author"}>
            {message.author}
          </span>
        </li>
      );
    });

    var none;
    if (0 === this.state.count) {
      var text = (this.state.filter.search ? 'No matches' : 'No messages');
      none = (<div className={CLASS_ROOT + "__no-matches"}>{text}</div>);
    }

    var spinner;
    if (this.state.messages.length < this.state.count) {
      spinner = (<div className={CLASS_ROOT + "__spinner spinner"}></div>);
    }

    var addControl;
    if (this.props.newUrl) {
      addControl = (
        <a className={CLASS_ROOT + "__add control-icon"} href={this.props.newUrl}>
          <AddIcon />
        </a>
      );
    }

    return (
      <div className={classes.join(' ')}>
        <header className={CLASS_ROOT + "__header"}>
          <h1 className={CLASS_ROOT + "__title"}>Library</h1>
          <SearchInput className={CLASS_ROOT + "__search"}
            text={this.state.filter.search}
            placeholder="Search: Title, Book, Author, Date"
            suggestionsPath={'/messages/suggestions?q='}
            onChange={this._onChangeSearch} />
          {addControl}
        </header>
        {none}
        <ol className={CLASS_ROOT + "__messages list-bare"}>
          {messages}
        </ol>
        {spinner}
        <div className={CLASS_ROOT + "__count"}>{this.state.count}</div>
      </div>
    );
  }
});

module.exports = Messages;
