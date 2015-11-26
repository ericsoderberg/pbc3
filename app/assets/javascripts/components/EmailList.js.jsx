var Index = require('./Index');
var CloseIcon = require('./CloseIcon');

var CLASS_ROOT = "email-list";

var EmailList = React.createClass({

  // match app/views/filled_forms/_index.json.jbuilder
  propTypes: {
    count: React.PropTypes.number.isRequired,
    addresses: React.PropTypes.array.isRequired,
    filter: React.PropTypes.object,
    form: React.PropTypes.object,
    newUrl: React.PropTypes.string
  },

  _renderEmailList: function (emailAddress) {
    return [
      <span key="address" className={CLASS_ROOT + "__address"}>
        {emailAddress.emailAddress}
      </span>,
      <form key="remove" action={emailAddress.removeUrl} method="post"
        accept-charset="UTF-8">
        <input name="utf8" type="hidden" value="✓" />
        <input type="hidden" name="authenticity_token"
          value={emailAddress.authenticityToken} />
        <button type="submit" className="control-icon"><CloseIcon /></button>
      </form>
    ];
  },

  render: function () {
    return (
      <Index title={this.props.emailList.name} itemRenderer={this._renderEmailList}
        responseProperty="emailAddresses" items={this.props.emailAddresses}
        count={this.props.count} filter={this.props.filter}
        noneMessage="No addresses are associated with this email list yet"
        newUrl={this.props.newUrl} />
    );
  }
});

module.exports = EmailList;
