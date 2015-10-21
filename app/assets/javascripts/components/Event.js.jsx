var Event = React.createClass({

  render: function() {
    var event = this.props.event;
    return (
      <div className="event">
        <h2 className="event__times">{event.friendlyTimes}</h2>
        <h3 className="event__location">{event.location}</h3>
      </div>
    );
  }
});

module.exports = Event;
