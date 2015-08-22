var Index = require('./Index');
var EditIcon = require('./EditIcon');

var CLASS_ROOT = "forms";

var Forms = React.createClass({

  // match app/views/forms/_index.json.jbuilder
  propTypes: {
    newUrl: React.PropTypes.string,
    forms: React.PropTypes.array.isRequired,
    count: React.PropTypes.number.isRequired,
    filter: React.PropTypes.object
  },

  _renderForm: function (form) {
    return (
      <a className={CLASS_ROOT + "__form-name"}
        href={form.editUrl}>
        {form.name}
      </a>
    );
  },

  render: function () {
    return (
      <Index title="Forms" itemRenderer={this._renderForm}
        responseProperty="forms" items={this.props.forms}
        count={this.props.count} filter={this.props.filter}
        newUrl={this.props.newUrl} />
    );
  }
});

module.exports = Forms;
