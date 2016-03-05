import React, { Component } from 'react';
import CalendarIcon from './icons/CalendarIcon';

export default class Event extends Component {

  render () {
    var event = this.props.event;
    var name;
    if (event.name !== this.props.pageName) {
      name = (
        <h2 className="event__name">{event.name}</h2>
      );
    }
    return (
      <div className="event">
        {name}
        <h3 className="event__times">{event.friendlyTimes}</h3>
        <h4 className="event__location">{event.location}</h4>
        <a className="control-icon" href={event.calendarUrl}><CalendarIcon /></a>
      </div>
    );
  }
};