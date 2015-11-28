var moment = require('moment');
var Index = require('./Index');
var EditIcon = require('./icons/EditIcon');

var CLASS_ROOT = "holidays";

var Holidays = React.createClass({

  // match app/views/holidays/_index.json.jbuilder
  propTypes: {
    newUrl: React.PropTypes.string,
    holidays: React.PropTypes.array.isRequired,
    count: React.PropTypes.number.isRequired,
    filter: React.PropTypes.object
  },

  _renderHoliday: function (holiday) {
    var date = moment(holiday.date);
    return [
      <span>{date.format('MMM D YYYY')}</span>,
      <a className={CLASS_ROOT + "__holiday-name"} href={holiday.editUrl}>{holiday.name}</a>
    ];
  },

  render: function () {
    return (
      <Index title="Holidays" itemRenderer={this._renderHoliday}
        responseProperty="holidays" items={this.props.holidays}
        count={this.props.count} filter={this.props.filter}
        newUrl={this.props.newUrl} />
    );
  }
});

module.exports = Holidays;
