import React, { Component, PropTypes } from 'react';
import moment from 'moment';
import Index from './Index';
import IndexItem from './IndexItem';

export default class Holidays extends Component {

  _renderHoliday (holiday) {
    var date = moment(holiday.date);
    return (
      <IndexItem key={holiday.id} url={holiday.editUrl}>
        {date.format('MMM D YYYY')}
        {holiday.name}
      </IndexItem>
    );
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
