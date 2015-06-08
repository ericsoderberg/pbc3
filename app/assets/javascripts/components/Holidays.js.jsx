var moment = require('moment');
var Index = require('./Index');

var CLASS_ROOT = "holidays";

var Holidays = React.createClass({

  propTypes: {
    holidays: React.PropTypes.array.isRequired,
    count: React.PropTypes.number.isRequired,
    filter: React.PropTypes.object
  },

  _renderHoliday: function (holiday) {
    var date = moment(holiday.date);
    return (
      <div className={CLASS_ROOT + "__holiday"}>
        <span>{date.format('MMM D YYYY')}</span>
        <a className={CLASS_ROOT + "__holiday-name"} href={holiday.url}>{holiday.name}</a>
        <a href={holiday.calendarUrl}>Calendar</a>
        <a href={holiday.editUrl}>Edit</a>
      </div>
    );
  },

  render: function () {
    return (
      <Index title="Holidays" itemRenderer={this._renderHoliday}
        responseProperty="holidays" items={this.props.holidays}
        count={this.props.count} filter={this.props.filter} />
    );
  }
});

module.exports = Holidays;
