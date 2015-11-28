var moment = require('moment');
var Index = require('./Index');
var EditIcon = require('./icons/EditIcon');

var CLASS_ROOT = "newsletters";

var Newsletters = React.createClass({

  // match app/views/newsletters/_index.json.jbuilder
  propTypes: {
    newUrl: React.PropTypes.string,
    newsletters: React.PropTypes.array.isRequired,
    count: React.PropTypes.number.isRequired,
    filter: React.PropTypes.object
  },

  _renderNewsletter: function (newsletter) {
    var date = moment(newsletter.publishedAt);
    return (
      <a className={CLASS_ROOT + "__newsletter-name"} href={newsletter.url}>
        <span>{date.format('MMM D YYYY')}</span> {newsletter.name}
      </a>
    );
  },

  render: function () {
    return (
      <Index title="Newsletters" itemRenderer={this._renderNewsletter}
        responseProperty="newsletters" items={this.props.newsletters}
        count={this.props.count} filter={this.props.filter}
        newUrl={this.props.newUrl} />
    );
  }
});

module.exports = Newsletters;
