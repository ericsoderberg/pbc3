import React, { Component, PropTypes } from 'react';
import ReactDOM from 'react-dom';
import { Link } from 'react-router';
import { connect } from 'react-redux';
import { loadSearch, searchQuery, unloadSearch } from '../actions/actions';
import CloseIcon from './icons/CloseIcon';

class Search extends Component {

  constructor () {
    super();
    this._onChange = this._onChange.bind(this);
    this._onClear = this._onClear.bind(this);
    this.state = {query: ''};
  }

  componentDidMount () {
    ReactDOM.findDOMNode(this.refs.input).focus();
    this.props.dispatch(loadSearch());
  }

  componentWillUnmount () {
    this.props.dispatch(unloadSearch());
  }

  static fetchData () {
    this.props.dispatch(loadSearch());
  }

  _onChange (event) {
    var query = event.target.value;
    this.setState({query: query}, () => {
      clearTimeout(this._timer);
      this._timer = setTimeout(() => {
        this.props.dispatch(searchQuery(this.state.query));
      }, 100);
    });
  }

  _onClear () {
    var query = '';
    this.setState({query: query}, function () {
      this.props.dispatch(loadSearch(this.state.query));
      this.refs.input.getDOMNode().focus();
    });
  }

  render () {
    const { search: {results} } = this.props;
    const { query } = this.state;
    var clearClasses = ["search__clear"];
    if (query) {
      clearClasses.push("search__clear--active");
    }

    var summary;
    if (results && results.length > 0) {
      if (results < 10) {
        summary = 'matched ' + results.length;
      }
    } else if (query) {
      summary = 'no matches';
    }

    let items;
    if (results) {
      items = results.map((result, index) => {
        let link;
        if (result.path) {
          link = <Link to={result.path}>{result.name}</Link>;
        } else {
          link = <a href={result.path}>{result.name}</a>;
        }
        return (
          <li key={`${result.url}${index}`} className="search__result">
            <h4 className="search__result-name">{link}</h4>
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
          {items}
        </ol>
      </div>
    );
  }
};

Search.propTypes = {
  search: PropTypes.shape({
    query: PropTypes.string,
    results: PropTypes.array
  })
};

let select = (state) => ({search: state.search});

export default connect(select)(Search);
