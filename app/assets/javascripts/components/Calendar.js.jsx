var moment = require('moment');
var SearchInput = require('./SearchInput');
var REST = require('./REST');
var SpinnerIcon = require('./SpinnerIcon');
var Router = require('./Router');

var Calendar = React.createClass({
  
  propTypes: {
    weeks: React.PropTypes.array.isRequired,
    daysOfWeek: React.PropTypes.array.isRequired
  },
  
  _onChangeSearch: function (search) {
    var path = '?';
    if (search) {
      path += 'search=' + encodeURIComponent(search);
    }
    Router.replace(path);
    this.setState({
      weeks: [],
    });
    //console.log('!!! Calendar _onChangeSearch', path);
    REST.get(path, function (response) {
      this.setState({
        weeks: response.weeks,
        filter: response.filter,
      });
    }.bind(this));
  },
  
  getInitialState: function () {
    return {
      //filterActive: false,
      weeks: this.props.weeks || [],
      filter: this.props.filter
    };
  },
 
  render: function () {
    var daysOfWeek = this.props.daysOfWeek.map(function (dayOfWeek) {
      return (<li className="calendar__day">{dayOfWeek}</li>);
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
          return (
            <li className="calendar__event">
              <span className="calendar__event-time">{start.format('h:mm a')}</span>
              <a href={event.url}>{event.name}</a>
            </li>
          );
        });
        return (
          <li className="calendar__day">
            <div className="calendar__day-date">
              {dayOfWeek}
              {month}
              {date.format('D')}
            </div>
            <ol className="calendar__events list-bare">
              {events}
            </ol>
          </li>
        );
      });
      return (
        <li className="calendar__week">
          <ol className="calendar__days list-bare">
            {days}
          </ol>
        </li>
      );
    });
    
    return (
      <div className="calendar">
        <header className="calendar__header">
          <h1 className="calendar__title">Calendar</h1>
          <SearchInput className="calendar__search"
            text={this.state.filter.search}
            suggestionsPath={'/calendar/suggestions?q='}
            onChange={this._onChangeSearch} />
        </header>
        <ol className="calendar__weeks list-bare">
          <li className="calendar__week calendar__week--header">
            <ol className="calendar__days list-bare">
              {daysOfWeek}
            </ol>
          </li>
          {weeks}
        </ol>
        <div className="calendar__spinner spinner"></div>
      </div>
    );
  }
});

module.exports = Calendar;
