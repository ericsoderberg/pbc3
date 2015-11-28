var moment = require('moment');
var SearchInput = require('./SearchInput');
var AddIcon = require('./icons/AddIcon');
var REST = require('./REST');
var SpinnerIcon = require('./icons/SpinnerIcon');
var Router = require('./Router');

var Calendar = React.createClass({

  propTypes: {
    weeks: React.PropTypes.array.isRequired,
    daysOfWeek: React.PropTypes.array.isRequired,
    next: React.PropTypes.string.isRequired,
    previous: React.PropTypes.string.isRequired
  },

  _onChangeSearch: function (search) {
    var path = '?';
    if (search) {
      path += 'search=' + encodeURIComponent(search);
    }
    Router.replace(path);
    clearTimeout(this._resetTimer);
    this._resetTimer = setTimeout(function () {
      this.setState({
        weeks: [],
      });
    }, 100);

    //console.log('!!! Calendar _onChangeSearch', path);
    REST.get(path, function (response) {
      clearTimeout(this._resetTimer);
      this.setState({
        weeks: response.weeks,
        filter: response.filter,
        next: response.next,
        previous: response.previous
      });
    }.bind(this));
  },

  getInitialState: function () {
    return {
      //filterActive: false,
      weeks: this.props.weeks || [],
      filter: this.props.filter,
      next: this.props.next,
      previous: this.props.previous
    };
  },

  render: function () {
    var daysOfWeek = this.props.daysOfWeek.map(function (dayOfWeek) {
      return (
        <div key={dayOfWeek} className="calendar__day">{dayOfWeek}</div>
      );
    });

    var weeks = this.state.weeks.map(function (week) {
      var days = week.days.map(function (day) {
        var date = moment(day.date);
        var dayOfWeek = (<span className="calendar__day-date-weekday">{date.format('dddd')}</span>);
        var monthClasses = ["calendar__day-date-month"];
        if (1 === date.date()) {
          monthClasses.push("calendar__day-date-month--first");
        }
        var month = (<span className={monthClasses.join(' ')}>{date.format('MMMM')}</span>);
        var events = day.events.map(function (event) {
          var start = moment(event.startAt);
          var time;
          if (start.isAfter(date)) {
            time = <span className="calendar__event-time">{start.format('h:mm a')}</span>
          }
          return (
            <li key={event.url} className="calendar__event">
              {time}
              <a href={event.url}>{event.name}</a>
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
            text={this.state.filter.search}
            suggestionsPath={'/calendar/suggestions?q='}
            onChange={this._onChangeSearch} />
          <a className={"calendar__add control-icon"} href={this.props.newUrl}>
            <AddIcon />
          </a>
        </header>
        <div className="calendar__week calendar__week--header">
          {daysOfWeek}
        </div>
        {weeks}
        <div className="calendar__nav">
          <a onClick={this._onChangeSearch.bind(this, this.state.previous)}>
            {this.state.previous}
          </a>
          <a onClick={this._onChangeSearch.bind(this, '')}>
            Today
          </a>
          <a onClick={this._onChangeSearch.bind(this, this.state.next)}>
            {this.state.next}
          </a>
        </div>
      </div>
    );
  }
});

module.exports = Calendar;
