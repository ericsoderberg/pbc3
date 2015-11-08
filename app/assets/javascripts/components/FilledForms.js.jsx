var Index = require('./Index');
var EditIcon = require('./EditIcon');

var CLASS_ROOT = "filled-forms";

var FilledForms = React.createClass({

  // match app/views/filled_forms/_index.json.jbuilder
  propTypes: {
    count: React.PropTypes.number.isRequired,
    editUrl: React.PropTypes.string,
    filledForms: React.PropTypes.array.isRequired,
    filter: React.PropTypes.object,
    form: React.PropTypes.object,
    newUrl: React.PropTypes.string
  },

  _renderFilledForm: function (filledForm) {
    return (
      <a className={CLASS_ROOT + "__form-name"}
        href={filledForm.editUrl}>
        {filledForm.name}
      </a>
    );
  },

  render: function () {
    return (
      <Index title={this.props.form.name} itemRenderer={this._renderFilledForm}
        responseProperty="filledForms" items={this.props.filledForms}
        count={this.props.count} filter={this.props.filter}
        newUrl={this.props.newUrl} editUrl={this.props.editUrl} />
    );
  }
});

module.exports = FilledForms;
