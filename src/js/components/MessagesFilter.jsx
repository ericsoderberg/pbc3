import React, { Component, PropTypes } from 'react';
import Range from './Range');
import BooksFilter from './BooksFilter');

export default class MessagesFilter extends Component {

  _onChangeSearch (event) {
    var search = event.target.value;
    var filter = this.state.filter;
    filter.search = search;
    this.setState({filter: filter}, function () {
      clearTimeout(this._timer);
      this._timer = setTimeout(function () {
        this.props.onChange(filter);
      }.bind(this), 500);
    });
  }

  _onChangeBooks (books) {
    var filter = this.state.filter;
    filter.books = books;
    this.props.onChange(filter);
    this.setState({filter: filter});
  }

  _onChangeAuthor (event) {
    var author = event.target.value;
    var filter = this.state.filter;
    if ('All authors' !== author) {
      filter.author = author;
    } else {
      delete filter.author;
    }
    this.props.onChange(filter);
    this.setState({filter: filter});
  }

  _onChangeYear (year) {
    var filter = this.state.filter;
    filter.year = year;
    this.props.onChange(filter);
    this.setState({filter: filter});
  }

  getInitialState () {
    return {filter: this.props.filter};
  }

  render () {
    var filter = this.state.filter;
    var classes = ["messages-filter"];
    if (this.props.className) {
      classes.push(this.props.className);
    }

    var authors = filter.authors.map(function (author) {
      return (<option key={author}>{author}</option>);
    });

    return (
      <div className={classes.join(' ')}>
        <input className="messages-filter__search"
          placeholder="Search"
          value={filter.search}
          onChange={this._onChangeSearch} />
        <Range className="messages-filter__dates"
          value={filter.year}
          min={filter.oldestYear}
          max={filter.newestYear}
          onChange={this._onChangeYear} />
        <select className="messages-filter__authors"
          value={filter.author}
          onChange={this._onChangeAuthor}>
          {authors}
        </select>
        <BooksFilter structure={filter.structure}
          books={filter.books}
          onChange={this._onChangeBooks} />
      </div>
    );
  }
};

module.exports = MessagesFilter;
