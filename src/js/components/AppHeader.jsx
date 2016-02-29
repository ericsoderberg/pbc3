import React, { Component, PropTypes } from 'react';
import { Link } from 'react-router';

const CLASS_NAME = 'app-header';

export default class AppHeader extends Component {
  render () {
    return (
      <header className={CLASS_NAME}>
        <div className={`${CLASS_NAME}__contents`}>
          <Link className={`${CLASS_NAME}__site`} to="/">
            <img src={this.props.logoUrl} />
          </Link>
        </div>
      </header>
    );
  }
};

AppHeader.propTypes = {
  logoUrl: PropTypes.string
};
