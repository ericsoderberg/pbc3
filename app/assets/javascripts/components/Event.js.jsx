var Event = React.createClass({
 
  render: function() {
    var event = this.props.event;
    return (
      <div className="event">
        <h3 className="event__name">{event.name}</h3>
        <div className="event__times">{event.friendlyTimes}</div>
        <div className="event__location">{event.location}</div>
      </div>
    );
  }
});

module.exports = Event;
