import React, { Component, PropTypes } from 'react';
import { Link } from 'react-router';
import Index from './Index';

const CLASS_ROOT = "pages";

export default class Pages extends Component {

  _renderPage (page) {
    return (
      <Link className={`${CLASS_ROOT}__page-name`} to={page.path}>
        {page.name}
      </Link>
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
