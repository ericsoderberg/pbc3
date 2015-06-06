
var MessagesSearch = React.createClass({
  
  _onChange: function (event) {
    var search = event.target.value;
    this.setState({search: search}, function () {
      clearTimeout(this._timer);
      this._timer = setTimeout(function () {
        this.props.onChange(search);
      }.bind(this), 500);
    });
  },
  
  _onFocus: function (event) {
    var input = event.target;
    setTimeout(function () {input.select();}, 1);
  },
  
  getInitialState: function () {
    return {search: this.props.filter.search};
  },
 
  render: function () {
    var classes = ["messages-search"];
    if (this.props.className) {
      classes.push(this.props.className);
    }
    
    return (
      <div className={classes.join(' ')}>
        <input ref="input" className="messages-search__input"
          placeholder="Search: Title, Book, Author, Year"
          value={this.state.search}
          onChange={this._onChange}
          onFocus={this._onFocus} />
        <ol className="messages-search__suggestions">
        </ol>
      </div>
    );
  }
});

module.exports = MessagesSearch;
