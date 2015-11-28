var CloseIcon = require('./icons/CloseIcon');
var REST = require('./REST');
var Router = require('./Router');

var Search = React.createClass({

  propTypes: {
    query: React.PropTypes.string,
    results: React.PropTypes.array
  },

  _doSearch: function () {
    if (this.state.query) {
      var path = '?q=' + encodeURIComponent(this.state.query);
      Router.replace(path);
      REST.get(path, function (response) {
        this.setState({results: response.results});
        //this._doSearch(); // in case the query has changed since we sent it
      }.bind(this));
    } else {
      Router.replace('?');
      this.setState({results: []});
    }
  },

  _onChange: function (event) {
    var query = event.target.value;
    this.setState({query: query}, function () {
      clearTimeout(this._timer);
      this._timer = setTimeout(this._doSearch, 100);
    });
  },

  _onClickClear: function () {
    var query = '';
    this.setState({query: query}, function () {
      this._doSearch();
      this.refs.input.getDOMNode().focus();
    });
  },

  getInitialState: function () {
    return {
      query: this.props.query,
      results: this.props.results
    };
  },

  componentDidMount: function () {
    this.refs.input.getDOMNode().focus();
  },

  render: function() {
    var clearClasses = ["search__clear"];
    if (this.state.query) {
      clearClasses.push("search__clear--active");
    }

    var summary;
    if (this.state.results && this.state.results.length > 0) {
      if (this.state.results < 10) {
        summary = 'matched ' + this.state.results.length;
      }
    } else if (this.state.query) {
      summary = 'no matches';
    }

    var results = '';
    if (this.state.results) {
      results = this.state.results.map(function (result) {
        return (
          <li key={result.name + result.url} className="search__result">
            <h4 className="search__result-name"><a href={result.url}>{result.name}</a></h4>
            <div className="search__result-text">{result.text}</div>
          </li>
        );
      });
    }

    return (
      <div className="search">
        <header className="search__header">
          <input ref="input" className="search__input" placeholder="Type to search"
            value={this.state.query} onChange={this._onChange} />
          <span className={clearClasses.join(' ')} onClick={this._onClickClear}>
            <CloseIcon />
          </span>
        </header>
        <div className="search__summary">{summary}</div>
        <ol className="search__results list-bare">
          {results}
        </ol>
      </div>
    );
  }
});

module.exports = Search;
