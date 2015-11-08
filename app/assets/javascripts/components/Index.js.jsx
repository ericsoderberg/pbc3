var Router = require('./Router');
var REST = require('./REST');
var SpinnerIcon = require('./SpinnerIcon');
var SearchInput = require('./SearchInput');
var AddIcon = require('./AddIcon');
var EditIcon = require('./EditIcon');

var CLASS_ROOT = "index";

var Index = React.createClass({

  propTypes: {
    title: React.PropTypes.string.isRequired,
    itemRenderer: React.PropTypes.func.isRequired,
    responseProperty: React.PropTypes.string.isRequired,
    items: React.PropTypes.array.isRequired,
    count: React.PropTypes.number.isRequired,
    filter: React.PropTypes.object,
    searchPlaceholder: React.PropTypes.string,
    editUrl: React.PropTypes.string,
    newUrl: React.PropTypes.string
  },

  getDefaultProps: function () {
    return {
      searchPlaceholder: "Search"
    };
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
        items: response[this.props.responseProperty],
        filter: response.filter,
        count: response.count,
        changing: false
      });
    }.bind(this));
  },

  _onScroll: function (event) {
    var bodyRect = document.body.getBoundingClientRect();
    if (bodyRect.bottom < (window.innerHeight + 100) && this.state.items.length < this.state.count) {
      clearTimeout(this._scrollTimer);
      this._scrollTimer = setTimeout(function () {
        // get the next page's worth
        var path = '?offset=' + this.state.items.length;
        if (this.state.filter.search) {
          path += '&search=' + encodeURIComponent(this.state.filter.search);
        }
        REST.get(path, function (response) {
          var items = this.state.items.concat(response[this.props.responseProperty]);
          this.setState({
            items: items,
          });
        }.bind(this));
      }.bind(this), 200);
    }
  },

  getInitialState: function () {
    return {
      items: this.props.items || [],
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

    var items = this.state.items.map(function (item) {
      return (
        <li key={item.id} className={CLASS_ROOT + "__item"}>
          {this.props.itemRenderer(item)}
        </li>
      );
    }, this);

    var none;
    if (0 === this.state.count) {
      var text = (this.state.filter.search ? 'No matches' : 'None');
      none = (<div className={CLASS_ROOT + "__no-matches"}>{text}</div>);
    }

    var spinner;
    if (this.state.items.length < this.state.count) {
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

    var editControl;
    if (this.props.editUrl) {
      editControl = (
        <a className={CLASS_ROOT + "__edit control-icon"} href={this.props.editUrl}>
          <EditIcon />
        </a>
      );
    }

    return (
      <div className={classes.join(' ')}>
        <header className={CLASS_ROOT + "__header"}>
          <h1 className={CLASS_ROOT + "__title"}>{this.props.title}</h1>
          <SearchInput className={CLASS_ROOT + "__search"}
            text={this.state.filter.search}
            placeholder={this.props.searchPlaceholder}
            onChange={this._onChangeSearch} />
          {addControl}
          {editControl}
        </header>
        {none}
        <ol className={CLASS_ROOT + "__items list-bare"}>
          {items}
        </ol>
        {spinner}
        <div className={CLASS_ROOT + "__count"}>{this.state.count}</div>
      </div>
    );
  }
});

module.exports = Index;
