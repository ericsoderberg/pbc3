var Menu = React.createClass({

  propTypes: {
    direction: React.PropTypes.oneOf(['up', 'down'])
  },

  getDefaultProps: function () {
    return {
      direction: 'down'
    };
  },

  _onClickControl: function (event) {
    this.setState({active: true});
    document.addEventListener('click', this._onBodyClick);
  },

  _onBodyClick: function () {
    this.setState({active: false});
    document.removeEventListener('click', this._onBodyClick);
  },

  getInitialState: function () {
    return {active: false};
  },

  componentDidMount: function () {
  },

  componentWillUnmount: function () {
    if (this.state.active) {
      document.removeEventListener('click', this._onBodyClick);
    }
  },

  render: function() {
    var classes = ["menu"];
    var controlClasses = ["menu__control control-icon"];
    if (this.state.active) {
      classes.push("menu--active");
      controlClasses.push("control-icon--active");
    }
    if (this.props.direction) {
      classes.push("menu--" + this.props.direction);
      controlClasses.push("control-icon--active-" + this.props.direction);
    }
    if (this.props.className) {
      classes.push(this.props.className);
    }

    var items = [];
    if (this.props.actions) {
      items = this.props.actions.map(function (action, index) {
        var label = action.label;
        if (action.image) {
          label = (<img src={action.image} />);
        }
        return (
          <li key={action.label || index}>
            <a href={action.url} className="menu__action">{label}</a>
          </li>
        );
      });
    }

    return (
      <div className={classes.join(' ')}>
        <div className={controlClasses.join(' ')} onClick={this._onClickControl}>
          {this.props.icon}
        </div>
        <ol className="menu__actions list-bare">
          {items}
        </ol>
      </div>
    );
  }
});

module.exports = Menu;
