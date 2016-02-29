import React, { Component, PropTypes } from 'react';
import moment from 'moment';
import Index from './Index';

var CLASS_ROOT = "newsletters";

export default class Newsletters extends Component {

  _renderNewsletter (newsletter) {
    var date = moment(newsletter.publishedAt);
    return (
      <a className={CLASS_ROOT + "__newsletter-name"} href={newsletter.url}>
        <span>{date.format('MMM D YYYY')}</span> {newsletter.name}
      </a>
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
