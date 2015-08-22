var Drop = require('../utils/Drop');

var MenuDrop = React.createClass({

  propTypes: {
    actions: React.PropTypes.arrayOf(React.PropTypes.object),
    direction: React.PropTypes.oneOf(['up', 'down', ])
  },

  render: function () {
    var actions = [];
    if (this.props.actions) {
      actions = this.props.actions.map(function (action, index) {
        var label = action.label;
        if (action.image) {
          label = (<img src={action.image} />);
        }
        return (
          <a key={action.label || index} href={action.url}
            className="menu__action">{label}</a>
        );
      });
    }

    return (
      <nav className="menu__actions">
        {actions}
        {this.props.children}
      </nav>
    );
  }
});

var Menu = React.createClass({

  propTypes: {
    actions: React.PropTypes.arrayOf(React.PropTypes.object)
  },

  getDefaultProps: function () {
    return {
      direction: 'down'
    };
  },

  _renderDrop: function () {
    return (
      <MenuDrop actions={this.props.actions}>
        {this.props.children}
      </MenuDrop>
    );
  },

  _open: function () {
    this._drop = Drop.add(this.refs.control.getDOMNode(),
      this._renderDrop(), {top: 'bottom', right: 'right'});
    this.setState({active: true});
    document.addEventListener('click', this._onElsewhere);
  },

  _close: function () {
    document.removeEventListener('click', this._onElsewhere);
    if (this._drop) {
      this._drop.remove();
      this._drop = null;
    }
    this.setState({active: false});
  },

  _onClickControl: function (event) {
    if (this.state.active) {
      this._close();
    } else {
      this._open();
    }
  },

  _onElsewhere: function () {
    this._close();
  },

  getInitialState: function () {
    return {active: false};
  },

  componentDidMount: function () {
  },

  componentWillUnmount: function () {
    if (this.state.active) {
      this._close();
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

    return (
      <div className={classes.join(' ')}>
        <div ref="control" className={controlClasses.join(' ')} onClick={this._onClickControl}>
          {this.props.icon}
        </div>
      </div>
    );
  }
});

module.exports = Menu;
