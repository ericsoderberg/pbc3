import React, { Component, PropTypes } from 'react';
import { Link } from 'react-router';
import Index from './Index';

const CLASS_ROOT = "email_lists";

export default class EmailLists extends Component {

  _renderEmailList (emailList) {
    return (
      <Link className={`${CLASS_ROOT}__name`} to={emailList.showPath}>
        {emailList.name}
      </Link>
    );
  }

  render () {
    return (
      <Index title="Email Lists" itemRenderer={this._renderEmailList}
        category="emailLists" index={{
          items: this.props.emailLists,
          count: this.props.count,
          filter: this.props.filter
        }}
        newUrl={this.props.newUrl} />
    );
  }
};

// match app/views/emailLists/_index.json.jbuilder
EmailLists.propTypes = {
  newUrl: PropTypes.string,
  emailLists: PropTypes.array,
  count: PropTypes.number,
  filter: PropTypes.object
};
