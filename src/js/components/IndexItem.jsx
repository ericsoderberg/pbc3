import React, { Component, PropTypes } from 'react';
import { Link } from 'react-router';

const CLASS_ROOT = "index-item";

export default class IndexItem extends Component {

  render () {
    const { path, url, children } = this.props;
    const className = `${CLASS_ROOT}__contents`;
    let link;
    if (path) {
      link = <Link to={path} className={className}>{children}</Link>;
    } else if (url) {
      link = <a href={url} className={className}>{children}</a>;
    } else {
      link = <div className={className}>{children}</div>;
    }
    return (
      <li className={CLASS_ROOT}>{link}</li>
    );
  }
};

IndexItem.propTypes = {
  path: PropTypes.string,
  url: PropTypes.string
};
