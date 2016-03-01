import React, { Component, PropTypes } from 'react';
import AddIcon from '../icons/AddIcon';
import CloseIcon from '../icons/CloseIcon';
import DragAndDrop from '../../utils/DragAndDrop';
import FormFieldOptionBuilder from './FormFieldOptionBuilder';
import formBuilderUtils from './formBuilderUtils';

var CLASS_ROOT = "form-builder";
var PLACEHOLDER_CLASS = `${CLASS_ROOT}__placeholder`;

export default class FormFieldEditor extends Component {

  constructor (props) {
    super(props);
    this._onUpdate = this._onUpdate.bind(this);
    this._onChange = this._onChange.bind(this);
    this._onToggle = this._onToggle.bind(this);
    this._onOptionUpdate = this._onOptionUpdate.bind(this);
    this._onOptionRemove = this._onOptionRemove.bind(this);
    this._onAddOption = this._onAddOption.bind(this);
    this._onAddOption = this._onAddOption.bind(this);
    this._dragStart = this._dragStart.bind(this);
    this._dragOver = this._dragOver.bind(this);
    this._dragEnd = this._dragEnd.bind(this);
    this.state = { field: this.props.field };
  }

  componentDidMount () {
    const component = this.refs.name || this.refs.help;
    component.focus();
  }

  _onUpdate (event) {
    event.preventDefault();
    this.props.onUpdate(this.state.field);
  }

  _onChange (name) {
    let field = this.state.field;
    field[name] = this.refs[name].value;
    this.setState({field: field});
  }

  _onToggle (name) {
    let field = this.state.field;
    field[name] = ! field[name];
    this.setState({field: field});
  }

  _onOptionUpdate (option) {
    let field = this.state.field;
    field.formFieldOptions =
      field.formFieldOptions.map(formFieldOption => {
        return (formBuilderUtils.idsMatch(option, formFieldOption) ?
          option : formFieldOption);
      });
    this.setState({field: field, newOption: null});
  }

  _onOptionRemove (id) {
    let field = this.state.field;
    field.formFieldOptions =
      field.formFieldOptions.filter(formFieldOption => {
        return (id !== formBuilderUtils.itemId(formFieldOption));
      });
    this.setState({field: field, newOption: null});
  }

  _onAddOption () {
    let field = this.props.field;
    const option = {
      _id: `__${(new Date()).getTime()}`,
      name: 'New option',
      optionType: 'fixed'
    };
    field.formFieldOptions.push(option);
    this.setState({field: field, newOption: option});
  }

  _dragStart (event) {
    this._dragAndDrop = DragAndDrop.start({
      event: event,
      itemClass: `${CLASS_ROOT}__field`,
      placeholderClass: PLACEHOLDER_CLASS,
      list: this.state.field.formFieldOptions.slice(0)
    });
  }

  _dragEnd (event) {
    let field = this.state.field;
    let options = this._dragAndDrop.end(event);
    options.forEach(function (option, index) {
      option.formFieldIndex = index + 1;
    });
    field.formFieldOptions = options;
    this.setState({field: field});
  }

  _dragOver (event) {
    this._dragAndDrop.over(event);
  }

  render () {
    var field = this.props.field;

    let name, help, required, monetary, defaultValue, dependsOnId, unitValue, limit;

    if ('instructions' !== field.fieldType) {

      name = (
        <div className="form__field">
          <label>Name</label>
          <input ref="name" type="text"
            onChange={this._onChange.bind(this, "name")} value={field.name} />
        </div>
      );

      help = (
        <div className="form__field">
          <label>Help</label>
          <input ref="help" type="text"
            onChange={this._onChange.bind(this, "help")} value={field.help} />
        </div>
      );

      required = (
        <div className="form__field">
          <label>Required</label>
          <input ref="required" type="checkbox"
            onChange={this._onToggle.bind(this, "required")}
            checked={field.required} />
        </div>
      );

      monetary = (
        <div className="form__field">
          <label>Monetary</label>
          <input ref="monetary" type="checkbox"
            onChange={this._onToggle.bind(this, "monetary")}
            checked={field.monetary} />
        </div>
      );

      let defaultType = ('count' === field.fieldType ? 'number' : 'text');
      let defaultInput = (
        <input ref="value" type={defaultType}
          onChange={this._onChange.bind(this, "value")} value={field.value} />
      );
      if (field.monetary && 'count' !== field.fieldType) {
        defaultInput = (
          <div className="form__field-decorated-input">
            <span className="form__field-decorated-input-prefix">$</span>
            {defaultInput}
          </div>
        );
      }
      defaultValue = (
        <div className="form__field">
          <label>Default value</label>
          {defaultInput}
        </div>
      );

      let dependsOnOptions = [<option key="none"></option>];
      this.props.form.formSections.some(function (formSection) {
        return formSection.formFields.some(function (formField) {
          if (formField.id === field.id) return true;
          if ('instructions' !== formField.fieldType) {
            dependsOnOptions.push(
              <option key={formField.id} label={formField.name}
                value={formField.id}/>
            );
          }
        });
      });

      if (dependsOnOptions.length > 1) {
        dependsOnId = (
          <div className="form__field">
            <label>Depends on</label>
            <select ref="dependsOnId" value={field.dependsOnId}
              onChange={this._onChange.bind(this, "dependsOnId")}>
              {dependsOnOptions}
            </select>
          </div>
        );
      }

      if ('count' === field.fieldType) {
        let unitValueType = (field.monetary ? 'number' : 'text');
        let unitValueInput = (
          <input ref="unitValue" type={unitValueType}
            onChange={this._onChange.bind(this, "unitValue")}
            value={field.unitValue} />
        );
        if (field.monetary) {
          unitValueInput = (
            <div className="form__field-decorated-input">
              <span className="form__field-decorated-input-prefix">$</span>
              {unitValueInput}
            </div>
          );
        }
        unitValue = (
          <div className="form__field">
            <label>Unit value</label>
            {unitValueInput}
          </div>
        );

        limit = (
          <div className="form__field">
            <label>Limit</label>
            <input ref="limit" type="number"
              onChange={this._onChange.bind(this, "limit")} value={field.limit} />
          </div>
        );
      }

    } else {

      help = (
        <div className="form__field">
          <textarea ref="help"
            onChange={this._onChange.bind(this, "help")} value={field.help} />
        </div>
      );
    }

    let options;
    if ('single choice' === field.fieldType ||
      'multiple choice' === field.fieldType) {
      const opts = field.formFieldOptions.map(function (option, index) {
        return (
          <FormFieldOptionBuilder key={formBuilderUtils.itemId(option)}
            fieldType={field.fieldType}
            option={option} onUpdate={this._onOptionUpdate}
            onRemove={this._onOptionRemove}
            edit={option === this.state.newOption}
            index={index}
            dragStart={this._dragStart}
            dragEnd={this._dragEnd}
            monetary={field.monetary} />
        );
      }, this);
      options = (
        <fieldset className={CLASS_ROOT + "__section"}>
          <legend>Options</legend>
          <div className="form__fields" onDragOver={this._dragOver}>
            {opts}
          </div>
          <a className={CLASS_ROOT + "__add control-icon"}
            onClick={this._onAddOption}>
            <AddIcon />
          </a>
        </fieldset>
      );
    }

    return (
      <form className="form form--compact">
        <div className="form__header">
          <span className="form__title">Edit {field.fieldType}</span>
          <a href="#" className="control-icon" onClick={this.props.onCancel}>
            <CloseIcon />
          </a>
        </div>
        <div className="form__contents">
          <fieldset>
            <div className="form__fields">
              {name}
              {help}
              {required}
              {monetary}
              {unitValue}
              {defaultValue}
              {limit}
              {dependsOnId}
            </div>
          </fieldset>
          {options}
        </div>
        <div className="form__footer">
          <button className="btn btn--primary" onClick={this._onUpdate}>
            OK<
          /button>
          <a href="#" onClick={this.props.onRemove}>Remove</a>
        </div>
      </form>
    );
  }
};

FormFieldEditor.propTypes = {
  field: PropTypes.object.isRequired,
  form: PropTypes.object.isRequired,
  onCancel: PropTypes.func.isRequired,
  onRemove: PropTypes.func.isRequired,
  onUpdate: PropTypes.func.isRequired
};
