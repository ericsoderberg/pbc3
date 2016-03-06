import React, { Component, PropTypes } from 'react';
import Index from './Index';
import IndexItem from './IndexItem';

export default class Pages extends Component {

  _renderPage (page) {
    return (
      <IndexItem key={page.id} path={page.path}>
        {page.name}
      </IndexItem>
    );
  }

  render () {
    return (
      <Index title="Pages" itemRenderer={this._renderPage}
        category="pages" index={{
          items: this.props.pages,
          count: this.props.count,
          filter: this.props.filter
        }}
        newUrl={this.props.newUrl} />
    );
  }
};

// match app/views/pages/_index.json.jbuilder
Pages.propTypes = {
  newUrl: PropTypes.string,
  pages: PropTypes.array,
  count: PropTypes.number,
  filter: PropTypes.object
};
