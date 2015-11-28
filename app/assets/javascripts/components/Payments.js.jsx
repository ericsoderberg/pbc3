var Index = require('./Index');
var EditIcon = require('./icons/EditIcon');

var CLASS_ROOT = "forms";

var Payments = React.createClass({

  // match app/views/forms/_index.json.jbuilder
  propTypes: {
    newUrl: React.PropTypes.string,
    payments: React.PropTypes.array.isRequired,
    count: React.PropTypes.number.isRequired,
    filter: React.PropTypes.object
  },

  _renderPayment: function (form) {
    return (
      <a className={CLASS_ROOT + "__form-name"}
        href={form.formFillsUrl}>
        {form.name}
      </a>
    );
  },

  render: function () {
    return (
      <Index title="Payments" itemRenderer={this._renderPayment}
        responseProperty="payments" items={this.props.payments}
        count={this.props.count} filter={this.props.filter}
        newUrl={this.props.newUrl} />
    );
  }
});

module.exports = Payments;
