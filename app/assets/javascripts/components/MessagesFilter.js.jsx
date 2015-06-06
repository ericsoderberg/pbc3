var Range = require('./Range');
var BooksFilter = require('./BooksFilter');

var MessagesFilter = React.createClass({
  
  _onChangeSearch: function (event) {
    var search = event.target.value;
    var filter = this.state.filter;
    filter.search = search;
    this.setState({filter: filter}, function () {
      clearTimeout(this._timer);
      this._timer = setTimeout(function () {
        this.props.onChange(filter);
      }.bind(this), 500);
    });
  },
  
  _onChangeBooks: function (books) {
    var filter = this.state.filter;
    filter.books = books;
    this.props.onChange(filter);
    this.setState({filter: filter});
  },
  
  _onChangeAuthor: function (event) {
    var author = event.target.value;
    var filter = this.state.filter;
    if ('All authors' !== author) {
      filter.author = author;
    } else {
      delete filter.author;
    }
    this.props.onChange(filter);
    this.setState({filter: filter});
  },
  
  _onChangeYear: function (year) {
    var filter = this.state.filter;
    filter.year = year;
    this.props.onChange(filter);
    this.setState({filter: filter});
  },
  
  getInitialState: function () {
    return {filter: this.props.filter};
  },
 
  render: function () {
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
});

module.exports = MessagesFilter;
