var Index = require('./Index');
var EditIcon = require('./EditIcon');

var CLASS_ROOT = "pages";

var Pages = React.createClass({

  // match app/views/resources/_index.json.jbuilder
  propTypes: {
    newUrl: React.PropTypes.string,
    pages: React.PropTypes.array.isRequired,
    count: React.PropTypes.number.isRequired,
    filter: React.PropTypes.object
  },

  _renderPage: function (page) {
    return (
      <a className={CLASS_ROOT + "__page-name"} href={page.url}>
        {page.name}
      </a>
    );
  },

  render: function () {
    return (
      <Index title="Pages" itemRenderer={this._renderPage}
        responseProperty="pages" items={this.props.pages}
        count={this.props.count} filter={this.props.filter}
        newUrl={this.props.newUrl} />
    );
  }
});

module.exports = Pages;
