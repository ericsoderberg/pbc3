var Index = require('./Index');
var EditIcon = require('./EditIcon');

var CLASS_ROOT = "email_lists";

var EmailLists = React.createClass({

  // match app/views/resources/_index.json.jbuilder
  propTypes: {
    newUrl: React.PropTypes.string,
    emailLists: React.PropTypes.array.isRequired,
    count: React.PropTypes.number.isRequired,
    filter: React.PropTypes.object
  },

  _renderEmailList: function (emailList) {
    return (
      <a className={CLASS_ROOT + "__name"} href={emailList.showUrl}>
        {emailList.name}
      </a>
    );
  },

  render: function () {
    return (
      <Index title="Email Lists" itemRenderer={this._renderEmailList}
        responseProperty="emailLists" items={this.props.emailLists}
        count={this.props.count} filter={this.props.filter}
        newUrl={this.props.newUrl} />
    );
  }
});

module.exports = EmailLists;
