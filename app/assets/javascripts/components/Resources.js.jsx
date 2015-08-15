var Index = require('./Index');
var EditIcon = require('./EditIcon');

var CLASS_ROOT = "resources";

var Resources = React.createClass({

  // match app/views/resources/_index.json.jbuilder
  propTypes: {
    newUrl: React.PropTypes.string,
    resources: React.PropTypes.array.isRequired,
    count: React.PropTypes.number.isRequired,
    filter: React.PropTypes.object
  },

  _renderResource: function (resource) {
    return [
      <a key="calendar" className={CLASS_ROOT + "__resource-name"}
        href={resource.calendarUrl}>
        {resource.name}
      </a>,
      <a key="edit" href={resource.editUrl} className="control-icon"><EditIcon /></a>
    ];
  },

  render: function () {
    return (
      <Index title="Resources" itemRenderer={this._renderResource}
        responseProperty="resources" items={this.props.resources}
        count={this.props.count} filter={this.props.filter}
        newUrl={this.props.newUrl} />
    );
  }
});

module.exports = Resources;
