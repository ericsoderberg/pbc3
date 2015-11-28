var CloseIcon = require('../icons/CloseIcon');

var FormFieldOptionEditor = React.createClass({

  propTypes: {
    option: React.PropTypes.object.isRequired,
    onCancel: React.PropTypes.func.isRequired,
    onRemove: React.PropTypes.func.isRequired,
    onUpdate: React.PropTypes.func.isRequired
  },

  _onUpdate: function (event) {
    event.preventDefault();
    this.props.onUpdate(this.state.option);
  },

  _onChange: function (name) {
    var option = this.state.option;
    option[name] = this.refs[name].getDOMNode().value;
    this.setState(option);
  },

  _onToggle: function (name) {
    option = this.state.option;
    option[name] = ! option[name];
    this.setState(option);
  },

  getInitialState: function () {
    return {option: this.props.option};
  },

  componentDidMount: function () {
    this.refs.name.getDOMNode().focus();
  },

  render: function () {
    var option = this.props.option;

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
              <div className="form__field">
                <label>Help</label>
                <input ref="help" type="text"
                  onChange={this._onChange.bind(this, "help")}
                  value={option.help} />
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
});

module.exports = FormFieldOptionEditor;
