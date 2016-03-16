import React, { Component, PropTypes } from 'react';
import Index from './Index';
import IndexItem from './IndexItem';

export default class Libraries extends Component {

  _renderLibrary (library) {
    return (
      <IndexItem key={library.id} path={library.messagesPath}>
        {library.name}
      </IndexItem>
    );
  }

  render () {
    return (
      <Index title="Libraries" itemRenderer={this._renderLibrary}
        category="libraries" index={{
          items: this.props.libraries,
          count: this.props.count,
          filter: this.props.filter
        }}
        newUrl={this.props.newUrl} />
    );
  }
};

// match app/views/libraries/_index.json.jbuilder
Libraries.propTypes = {
  newUrl: PropTypes.string,
  libraries: PropTypes.array,
  count: PropTypes.number,
  filter: PropTypes.object
};
