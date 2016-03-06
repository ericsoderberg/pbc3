import React, { Component, PropTypes } from 'react';
import moment from 'moment';
import Index from './Index';
import IndexItem from './IndexItem';

export default class Newsletters extends Component {

  _renderNewsletter (newsletter) {
    var date = moment(newsletter.publishedAt);
    return (
      <IndexItem key={newsletter.id} url={newsletter.url}>
        <span>{date.format('MMM D YYYY')}</span>
        {newsletter.name}
      </IndexItem>
    );
  }

  render () {
    return (
      <Index title="Newsletters" itemRenderer={this._renderNewsletter}
        category="newsletters" index={{
          items: this.props.newsletters,
          count: this.props.count,
          filter: this.props.filter
        }}
        newUrl={this.props.newUrl} />
    );
  }
};

// match app/views/newsletters/_index.json.jbuilder
Newsletters.propTypes = {
  newUrl: PropTypes.string,
  newsletters: PropTypes.array,
  count: PropTypes.number,
  filter: PropTypes.object
};
