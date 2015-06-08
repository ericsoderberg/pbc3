var Index = require('./Index');

var CLASS_ROOT = "resources";

var Resources = React.createClass({

  propTypes: {
    resources: React.PropTypes.array.isRequired,
    count: React.PropTypes.number.isRequired,
    filter: React.PropTypes.object
  },

  _renderResource: function (resource) {
    return (
      <div className={CLASS_ROOT + "__resource"}>
        <a className={CLASS_ROOT + "__resource-name"} href={resource.url}>{resource.name}</a>
        <a href={resource.calendarUrl}>Calendar</a>
        <a href={resource.editUrl}>Edit</a>
      </div>
    );
  },

  render: function () {
    return (
      <Index title="Resources" itemRenderer={this._renderResource}
        responseProperty="resources" items={this.props.resources}
        count={this.props.count} filter={this.props.filter} />
    );
  }
});

module.exports = Resources;
