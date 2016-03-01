import React, { Component, PropTypes } from 'react';
import Drop from '../utils/Drop';

class MenuDrop extends Component {

  render () {
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
};

MenuDrop.propTypes = {
  actions: PropTypes.arrayOf(PropTypes.object),
  direction: PropTypes.oneOf(['up', 'down'])
};

export default class Menu extends Component {

  constructor () {
    super();
    this._onClickControl = this._onClickControl.bind(this);
    this._onElsewhere = this._onElsewhere.bind(this);
    this.state = { active: false };
  }

  componentWillUnmount () {
    if (this.state.active) {
      this._close();
    }
  }

  _renderDrop () {
    return (
      <MenuDrop actions={this.props.actions}>
        {this.props.children}
      </MenuDrop>
    );
  }

  _open () {
    this._drop = Drop.add(this.refs.control,
      this._renderDrop(), {top: 'bottom', right: 'right'});
    this.setState({active: true});
    document.addEventListener('click', this._onElsewhere);
  }

  _close () {
    document.removeEventListener('click', this._onElsewhere);
    if (this._drop) {
      this._drop.remove();
      this._drop = null;
    }
    this.setState({active: false});
  }

  _onClickControl (event) {
    if (this.state.active) {
      this._close();
    } else {
      this._open();
    }
  }

  _onElsewhere () {
    this._close();
  }

  render () {
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
};

Menu.propTypes = {
  actions: PropTypes.arrayOf(PropTypes.object)
};

Menu.defaultProps = {
  direction: 'down'
};
