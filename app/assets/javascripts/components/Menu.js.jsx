
var Drop = React.createClass({

  propTypes: {
    actions: React.PropTypes.arrayOf(React.PropTypes.object),
    direction: React.PropTypes.oneOf(['up', 'down', ])
  },

  render: function () {
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
      <ol className="menu__actions list-bare">
        {items}
      </ol>
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

  _place: function () {
    var controlRect = this.refs.control.getDOMNode().getBoundingClientRect();
    var containerRect = this._container.getBoundingClientRect();
    var windowWidth = window.innerWidth;
    var windowHeight = window.innerHeight;

    // clear prior styling
    this._container.style.left = '';
    this._container.style.width = '';
    this._container.style.top = '';

    var width = Math.min(
      Math.max(controlRect.width, containerRect.width), windowWidth);
    var left = controlRect.left + controlRect.width - width;
    var top = controlRect.top + controlRect.height;

    if (left < 0) {
      left = controlRect.left;
    }
    if ((top + containerRect.height) > windowHeight) {
      top = controlRect.top - containerRect.height;
    }

    this._container.style.left = '' + left + 'px';
    this._container.style.width = '' + width + 'px';
    this._container.style.top = '' + top + 'px';
  },

  _renderDrop: function () {
    return (
      <Drop actions={this.props.actions}>
        {this.props.children}
      </Drop>
    );
  },

  _open: function () {
    // setup DOM
    this._container = document.createElement('div');
    this._container.classList.add('menu__drop');
    document.body.appendChild(this._container);
    React.render(this._renderDrop(), this._container);
    this._place();
    this.setState({active: true});
    document.addEventListener('click', this._onElsewhere);
    window.addEventListener('resize', this._onElsewhere);
  },

  _close: function () {
    React.unmountComponentAtNode(this._container);
    document.body.removeChild(this._container);
    this.setState({active: false});
    document.removeEventListener('click', this._onElsewhere);
    window.removeEventListener('resize', this._onElsewhere);
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
      document.removeEventListener('click', this._onElsewhere);
      window.removeEventListener('resize', this._onElsewhere);
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
