import React, { Component, PropTypes } from 'react';
import Index from './Index';
import IndexItem from './IndexItem';

export default class EmailLists extends Component {

  _renderEmailList (emailList) {
    return (
      <IndexItem key={emailList.id} path={emailList.showPath}>
        {emailList.name}
      </IndexItem>
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
