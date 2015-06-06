var moment = require('moment');
//var MessagesSearch = require('./MessagesSearch');
//var FilterIcon = require('./FilterIcon');
//var MessagesFilter = require('./MessagesFilter');
var SearchInput = require('./SearchInput');
var REST = require('./REST');
var SpinnerIcon = require('./SpinnerIcon');
var Router = require('./Router');

var Messages = React.createClass({
  
  propTypes: {
    messages: React.PropTypes.array.isRequired,
    count: React.PropTypes.number.isRequired,
    filter: React.PropTypes.object
  },
  
  /*
  _onClickFilter: function () {
    this.setState({filterActive: true});
    document.addEventListener('click', this._onBodyClick);
  },
  
  _onBodyClick: function (event) {
    // make sure this click came outside of the filter
    var element = event.target;
    while ((element = element.parentElement) && !element.classList.contains("messages__filter"));
    if (! element) {
      this.setState({filterActive: false});
      document.removeEventListener('click', this._onBodyClick);
    }
  },
  */
  
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
  
  /*
  _onChangeFilter: function (filter) {
    console.log('!!! Messages _onChangeFilter', filter);
    var path = '?year=' + encodeURIComponent(filter.year);
    if (filter.author && 'All authors' !== filter.author) {
      path += '&author=' + encodeURIComponent(filter.author);
    }
    if (filter.search) {
      path += '&search=' + encodeURIComponent(filter.search);
    }
    history.replaceState(null, null, path);
    REST.get(path, function (response) {
      this.setState({
        messages: response.messages.messages,
        filter: response.messages.filter,
        count: response.messages.count
      });
    }.bind(this));
  },
  */
  
  getInitialState: function () {
    return {
      //filterActive: false,
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
    //if (this.state.filterActive) {
    //  document.removeEventListener('click', this._onBodyClick);
    //}
    window.removeEventListener('scroll', this._onScroll);
  },
 
  render: function () {
    var classes = ["messages"];
    if (this.state.changing) {
      classes.push("messages--changing");
    }
    
    var year = null;
    var messages = this.state.messages.map(function (message) {
      var classes = ["messages__message"];
      var date = moment(message.date);
      if (! year || date.year() !== year) {
        classes.push("messages__message--year");
        year = date.year();
      }
      return (
        <li key={message.id} className={classes.join(' ')}>
          <span className="messages__message-year">{date.format('YYYY')}</span>
          <span className="messages__message-date">{date.format('MMM D')}</span>
          <a className="messages__message-title" href={message.url}>{message.title}</a>
          <span className="messages__message-verses">{message.verses}</span>
          <span className="messages__message-author">{message.author}</span>
        </li>
      );
    });
    
    var noMatches = '';
    if (0 === this.state.count) {
      noMatches = (<div className="messages__no-matches">No matches</div>);
    }
    
    var spinner = '';
    if (this.state.messages.length < this.state.count) {
      spinner = (<div className="messages__spinner spinner"></div>);
    }
    
    return (
      <div className={classes.join(' ')}>
        <header className="messages__header">
          <h1 className="messages__title">Library</h1>
          <SearchInput className="messages__search"
            text={this.state.filter.search}
            placeholder="Search: Title, Book, Author, Date"
            suggestionsPath={'/messages/suggestions?q='}
            onChange={this._onChangeSearch} />
          <span className="messages__count">{this.state.count}</span>
        </header>
        {noMatches}
        <ol className="messages__messages list-bare">
          {messages}
        </ol>
        {spinner}
      </div>
    );
    
    /*<MessagesSearch className="messages__search"
            filter={this.state.filter}
            onChange={this._onChangeSearch} />*/
    /*<div className={controlClasses.join(' ')} onClick={this._onClickFilter}>
            <FilterIcon />
          </div>*/
    /*<MessagesFilter className={filterClasses.join(' ')}
          filter={this.state.filter}
          onChange={this._onChangeFilter} />*/
  }
});

module.exports = Messages;
