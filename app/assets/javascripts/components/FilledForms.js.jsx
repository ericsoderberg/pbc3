var Index = require('./Index');
var moment = require('moment');
var EditIcon = require('./icons/EditIcon');

var CLASS_ROOT = "filled-forms";

var FilledForms = React.createClass({

  // match app/views/filled_forms/_index.json.jbuilder
  propTypes: {
    count: React.PropTypes.number.isRequired,
    editUrl: React.PropTypes.string,
    filledForms: React.PropTypes.array.isRequired,
    filter: React.PropTypes.object,
    form: React.PropTypes.object,
    newUrl: React.PropTypes.string,
    page: React.PropTypes.object
  },

  _renderFilledForm: function (filledForm) {
    var date = moment(filledForm.updatedAt);
    var parts = [
      <a key="name" className={CLASS_ROOT + "__form-name"}
        href={filledForm.editUrl}>
        {filledForm.name}
      </a>,
      <span key="date">{date.format('MMM D, YYYY')}</span>
    ];
    var version;
    if (this.props.form.version > 1) {
      parts.push(<span>{filledForm.version}</span>);
    }
    return parts;
  },

  render: function () {
    return (
      <Index title={this.props.form.name} itemRenderer={this._renderFilledForm}
        responseProperty="filledForms" items={this.props.filledForms}
        count={this.props.count} filter={this.props.filter}
        noneMessage="Nobody has filled out this form yet"
        newUrl={this.props.newUrl} editUrl={this.props.editUrl}
        page={this.props.page} />
    );
  }
});

module.exports = FilledForms;
