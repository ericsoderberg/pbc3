var Range = React.createClass({
  
  _onChange: function (event) {
    // throttle change volume
    var value = event.target.value;
    this.setState({value: value}, function () {
      clearTimeout(this._timer);
      this._timer = setTimeout(function () {
        this.props.onChange(value);
      }.bind(this), 500);
    });
  },
  
  getInitialState: function () {
    return {
      min: this.props.min,
      max: this.props.max,
      value: this.props.value
    };
  },
 
  render: function() {
    var classes = ["range"];
    if (this.props.className) {
      classes.push(this.props.className);
    }
    var chunks = [];
    for (var chunk = this.state.min;
      chunk < this.state.max;
      chunk += ((this.state.max - this.state.min) / 10)) {
      chunks.push((<option key={chunk}>{chunk}</option>));
    }
    return (
      <div className={classes.join(' ')}>
        <input className="range__range"
          type="range" name="range" list="chunks"
          value={this.state.value}
          onChange={this._onChange}
          min={this.state.min} max={this.state.max} />
        <datalist id="chunks">
          {chunks}
        </datalist>
        <input className="range__value"
          type="text" name="value"
          value={this.state.value} onChange={this._onChange} />
      </div>
    );
  }
});

module.exports = Range;
