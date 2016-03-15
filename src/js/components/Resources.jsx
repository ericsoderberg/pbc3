import React, { Component, PropTypes } from 'react';
import Index from './Index';
import IndexItem from './IndexItem';

export default class Resources extends Component {

  _renderResource (resource) {
    return (
      <IndexItem key={resource.id} url={resource.editUrl}>
        {resource.name}
      </IndexItem>
    );
  }

  render () {
    return (
      <Index title="Resources" itemRenderer={this._renderResource}
        category="resources" index={{
          items: this.props.resources,
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
