import React, { Component, PropTypes } from 'react';
import { Link } from 'react-router';
import { connect } from 'react-redux';
import { loadCalendar, searchCalendar, unloadCalendar } from '../actions/actions';
import moment from 'moment';
import SearchInput from './SearchInput';
import AddIcon from './icons/AddIcon';

class Calendar extends Component {

  constructor () {
    super();
    this._onChangeSearch = this._onChangeSearch.bind(this);
  }

  componentDidMount () {
    this.props.dispatch(loadCalendar());
  }

  componentWillUnmount () {
    this.props.dispatch(unloadCalendar());
  }

  _onChangeSearch (search) {
    this.props.dispatch(searchCalendar(search));
  }

  render () {
    const { calendar } = this.props;
    const daysOfWeek = calendar.daysOfWeek.map(function (dayOfWeek) {
      return (
        <div key={dayOfWeek} className="calendar__day">{dayOfWeek}</div>
      );
    });

    const weeks = calendar.weeks.map(function (week) {
      const days = week.days.map(function (day) {
        const date = moment(day.date);

        const dayOfWeek = (
          <span className="calendar__day-date-weekday">
            {date.format('dddd')}
          </span>
        );

        let monthClasses = ["calendar__day-date-month"];
        if (1 === date.date()) {
          monthClasses.push("calendar__day-date-month--first");
        }
        const month = (
          <span className={monthClasses.join(' ')}>
            {date.format('MMMM')}
          </span>
        );

        const events = day.events.map((event, index) => {
          const start = moment(event.startAt);
          let time;
          if (start.isAfter(date)) {
            time = (
              <span className="calendar__event-time">
                {start.format('h:mm a')}
              </span>
            );
          }
          let link;
          if (event.path) {
            link = <Link to={event.path}>{event.name}</Link>;
          } else {
            link = <a href={event.url}>{event.name}</a>;
          }
          return (
            <li key={event.url + index} className="calendar__event">
              {time}
              {link}
            </li>
          );
        });

        return (
          <div key={day.date} className="calendar__day">
            <div className="calendar__day-date">
              {dayOfWeek}
              {month}
              {date.format('D')}
            </div>
            <ol className="calendar__events list-bare">
              {events}
            </ol>
          </div>
        );
      });

      return (
        <div key={week.days[0].date} className="calendar__week">
          {days}
        </div>
      );
    });

    return (
      <div className="calendar calendar__weeks">
        <header className="calendar__header">
          <h1 className="calendar__title">Calendar</h1>
          <SearchInput className="calendar__search"
            text={calendar.filter.search}
            suggestionsPath={'/calendar/suggestions?q='}
            onChange={this._onChangeSearch} />
          <a className={"calendar__add control-icon"} href={calendar.newUrl}>
            <AddIcon />
          </a>
        </header>
        <div className="calendar__week calendar__week--header">
          {daysOfWeek}
        </div>
        {weeks}
        <div className="calendar__nav">
          <a onClick={this._onChangeSearch.bind(this, calendar.previous)}>
            {calendar.previous}
          </a>
          <a onClick={this._onChangeSearch.bind(this, '')}>
            Today
          </a>
          <a onClick={this._onChangeSearch.bind(this, calendar.next)}>
            {calendar.next}
          </a>
        </div>
      </div>
    );
  }
};

Calendar.propTypes = {
  calendar: PropTypes.shape({
    weeks: PropTypes.array.isRequired,
    daysOfWeek: PropTypes.array.isRequired,
    newUrl: PropTypes.string,
    next: PropTypes.string,
    previous: PropTypes.string
  }).isRequired
};

let select = (state) => ({calendar: state.calendar});

export default connect(select)(Calendar);
