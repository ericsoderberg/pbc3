import React, { Component, PropTypes } from 'react';
import Index from './Index';
import EditIcon from './icons/EditIcon';

var CLASS_ROOT = "resources";

export default class Resources extends Component {

  _renderResource (resource) {
    return [
      <a key="calendar" className={CLASS_ROOT + "__resource-name"}
        href={resource.calendarUrl}>
        {resource.name}
      </a>,
      <a key="edit" href={resource.editUrl} className="control-icon"><EditIcon /></a>
    ];
  }

  render () {
    return (
      <Index title="Resources" itemRenderer={this._renderResource}
        category="resources" index={{
          items: this.props.holidays,
          count: this.props.count,
          filter: this.props.filter
        }}
        newUrl={this.props.newUrl} />
    );
  }
};

// match app/views/resources/_index.json.jbuilder
Resources.propTypes = {
  newUrl: PropTypes.string,
  resources: PropTypes.array,
  count: PropTypes.number,
  filter: PropTypes.object
};
