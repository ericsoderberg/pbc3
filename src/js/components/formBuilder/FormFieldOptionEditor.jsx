import React, { Component, PropTypes } from 'react';
import CloseIcon from '../icons/CloseIcon';

export default class FormFieldOptionEditor extends Component {

  constructor (props) {
    super(props);
    this.state = { option: props.option };
  }

  componentDidMount () {
    this.refs.name.getDOMNode().focus();
  }

  _onUpdate (event) {
    event.preventDefault();
    this.props.onUpdate(this.state.option);
  }

  _onChange (name) {
    var option = this.state.option;
    option[name] = this.refs[name].getDOMNode().value;
    this.setState(option);
  }

  _onToggle (name) {
    option = this.state.option;
    option[name] = ! option[name];
    this.setState(option);
  }

  render () {
    var option = this.props.option;

    var value;
    if (this.props.monetary) {
      value = (
        <div className="form__field form__field--monetary">
          <label>Value</label>
          <input ref="value" type="number"
            onChange={this._onChange.bind(this, "value")}
            value={option.value} />
        </div>
      );
    }

    return (
      <form className="form form--compact">
        <div className="form__header">
          <span className="form__title">Edit Option</span>
          <a href="#" className="control-icon" onClick={this.props.onCancel}>
            <CloseIcon />
          </a>
        </div>
        <div className="form__contents">
          <fieldset>
            <div className="form__fields">
              <div className="form__field">
                <label>Name</label>
                <input ref="name" type="text"
                  onChange={this._onChange.bind(this, "name")}
                  value={option.name} />
              </div>
              {value}
              <div className="form__field">
                <label>Help</label>
                <input ref="help" type="text"
                  onChange={this._onChange.bind(this, "help")}
                  value={option.help} />
              </div>
              <div className="form__field">
                <label>Limit</label>
                <input ref="limit" type="number"
                  onChange={this._onChange.bind(this, "limit")}
                  value={option.limit} />
              </div>
            </div>
          </fieldset>
        </div>
        <div className="form__footer">
          <button className="btn btn--primary" onClick={this._onUpdate}>
            OK
          </button>
          <a href="#" onClick={this.props.onRemove}>Remove</a>
        </div>
      </form>
    );
  }
};

FormFieldOptionEditor.propTypes = {
  monetary: PropTypes.bool,
  option: PropTypes.object.isRequired,
  onCancel: PropTypes.func.isRequired,
  onRemove: PropTypes.func.isRequired,
  onUpdate: PropTypes.func.isRequired
};
