import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import Index from './Index';
import CloseIcon from './icons/CloseIcon';

const CLASS_ROOT = "email-list";

class EmailList extends Component {

  _renderEmailList (emailAddress) {
    return [
      <span key="address" className={`${CLASS_ROOT}__address`}>
        {emailAddress.emailAddress}
      </span>,
      <form key="remove" action={emailAddress.removeUrl} method="post"
        acceptCharset="UTF-8">
        <input name="utf8" type="hidden" value="✓" />
        <input type="hidden" name="authenticity_token"
          value={emailAddress.authenticityToken} />
        <button type="submit" className="control-icon"><CloseIcon /></button>
      </form>
    ];
  }

  render () {
    return (
      <Index title={this.props.emailList.name || 'List'}
        itemRenderer={this._renderEmailList}
        category="emailAddresses" context="emailList" index={{
          items: this.props.addresses,
          count: this.props.count,
          filter: this.props.filter
        }}
        noneMessage="No addresses are associated with this email list yet"
        newUrl={this.props.newUrl} />
    );
  }
};

// match app/views/email_lists/_index.json.jbuilder
EmailList.propTypes = {
  count: PropTypes.number,
  addresses: PropTypes.array,
  filter: PropTypes.object,
  emailList: PropTypes.object,
  newUrl: PropTypes.string
};

let select = (state) => ({emailList: state.index.context});

export default connect(select)(EmailList);
