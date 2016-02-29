import React, { Component, PropTypes } from 'react';
import moment from 'moment';
import Index from './Index';

var CLASS_ROOT = "holidays";

export default class Holidays extends Component {

  _renderHoliday (holiday) {
    var date = moment(holiday.date);
    return [
      <span key="date">{date.format('MMM D YYYY')}</span>,
      <a key="name" className={CLASS_ROOT + "__holiday-name"}
        href={holiday.editUrl}>{holiday.name}</a>
    ];
  }

  render () {
    return (
      <Index title="Holidays" itemRenderer={this._renderHoliday}
        category="holidays" index={{
          items: this.props.holidays,
          count: this.props.count,
          filter: this.props.filter
        }}
        newUrl={this.props.newUrl} />
    );
  }
};

// match app/views/holidays/_index.json.jbuilder
Holidays.propTypes = {
  newUrl: PropTypes.string,
  holidays: PropTypes.array,
  count: PropTypes.number,
  filter: PropTypes.object
};
