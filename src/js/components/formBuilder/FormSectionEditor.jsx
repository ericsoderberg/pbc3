import React, { Component, PropTypes } from 'react';
import CloseIcon from '../icons/CloseIcon';
import Drop from '../../utils/Drop';

export default class FormSectionEditor extends Component {

  constructor (props) {
    super(props);
    this._onUpdate = this._onUpdate.bind(this);
    this._onChange = this._onChange.bind(this);
    this._onToggle = this._onToggle.bind(this);
    this.state = { section: props.section };
  }

  componentDidMount () {
    this.refs.name.focus();
  }

  _onUpdate (event) {
    event.preventDefault();
    this.props.onUpdate(this.state.section);
  }

  _onChange (name) {
    let section = this.state.section;
    section[name] = this.refs[name].value;
    this.setState({section: section});
  }

  _onToggle (name) {
    let section = this.state.section;
    section[name] = ! section[name];
    this.setState({section: section});
  }

  render () {
    const section = this.props.section;

    let dependsOnId;
    let dependsOnOptions = [<option key="none"></option>];
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
};

FormSectionEditor.propTypes = {
  form: PropTypes.object.isRequired,
  onCancel: PropTypes.func.isRequired,
  onRemove: PropTypes.func.isRequired,
  onUpdate: PropTypes.func.isRequired,
  section: PropTypes.object.isRequired
};
