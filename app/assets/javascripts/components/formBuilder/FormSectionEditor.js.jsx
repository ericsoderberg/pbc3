var CloseIcon = require('../icons/CloseIcon');
var Drop = require('../../utils/Drop');

var FormSectionEditor = React.createClass({

  propTypes: {
    form: React.PropTypes.object.isRequired,
    onCancel: React.PropTypes.func.isRequired,
    onRemove: React.PropTypes.func.isRequired,
    onUpdate: React.PropTypes.func.isRequired,
    section: React.PropTypes.object.isRequired
  },

  _onUpdate: function (event) {
    event.preventDefault();
    this.props.onUpdate(this.state.section);
  },

  _onChange: function (name) {
    var section = this.state.section;
    section[name] = this.refs[name].getDOMNode().value;
    this.setState({section: section});
  },

  _onToggle: function (name) {
    section = this.state.section;
    section[name] = ! section[name];
    this.setState({section: section});
  },

  getInitialState: function () {
    return {section: this.props.section};
  },

  componentDidMount: function () {
    this.refs.name.getDOMNode().focus();
  },

  render: function () {
    var section = this.props.section;

    var dependsOnId;
    var dependsOnOptions = [<option key="none"></option>];
    this.props.form.formSections.some(function (formSection) {
      if (formSection.id === section.id) return true;
      formSection.formFields.some(function (formField) {
        if ('instructions' !== formField.fieldType) {
          dependsOnOptions.push(
            <option key={formField.id} label={formField.name} value={formField.id}/>
          );
        }
      });
    });

    if (dependsOnOptions.length > 1) {
      dependsOnId = (
        <div className="form__field">
          <label>Depends on</label>
          <select ref="dependsOnId" value={section.dependsOnId}
            onChange={this._onChange.bind(this, "dependsOnId")}>
            {dependsOnOptions}
          </select>
        </div>
      );
    }

    return (
      <form className="form form--compact drop">
        <div className="form__header">
          <span className="form__title">Edit Section</span>
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
                  onChange={this._onChange.bind(this, "name")} value={section.name} />
              </div>
              {dependsOnId}
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

module.exports = FormSectionEditor;
