import React, { Component, PropTypes } from 'react';
export default class Delete extends Component {

  _onDelete () {
    this._xhr = new XMLHttpRequest();
    this._xhr.open('DELETE', this.props.href);
    this._xhr.setRequestHeader("X-CSRF-Token", this.props.csrfToken);
    this._xhr.setRequestHeader("Accept", "application/json");
    this._xhr.onreadystatechange = function () {
      if (this._xhr.readyState == 4  && this._xhr.status == 200) {
        window.location = this._xhr.responseText;
      }
    }.bind(this);
    this._xhr.send();
  }

  _onCancel (event) {
    setTimeout(function () {this.setState({active: false})}.bind(this), 1);
  }

  _onClick (event) {
    this.setState({active: true});
  }

  getInitialState () {
    return {active: false};
  }

  render: function() {
    var classes = ["delete"];
    if (this.props.className) {
      classes.push(this.props.className);
    }
    var confirmClasses = ["delete__confirm"];
    if (this.state.active) {
      confirmClasses.push("delete__confirm--active");
    }
    return (
      <div className={classes.join(' ')}>
        <a className={"btn btn--delete"} onClick={this._onClick}>Delete</a>
        <div className={confirmClasses.join(' ')}>
          {this.props.confirm}
          <ul className="delete__confirm-actions">
          <li className="btn" onClick={this._onDelete}>{"Yes, delete"}</li>
          <li className="btn" onClick={this._onCancel}>{"Cancel"}</li>
          </ul>
        </div>
      </div>
    );
  }
};

module.exports = Delete;
