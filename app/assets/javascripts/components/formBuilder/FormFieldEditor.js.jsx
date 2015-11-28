var AddIcon = require('../icons/AddIcon');
var CloseIcon = require('../icons/CloseIcon');
var DragAndDrop = require('../../utils/DragAndDrop');
var FormFieldOptionBuilder = require('./FormFieldOptionBuilder');
var formBuilderUtils = require('./formBuilderUtils');

var CLASS_ROOT = "form-builder";
var PLACEHOLDER_CLASS = CLASS_ROOT + "__placeholder";

var FormFieldEditor = React.createClass({

  propTypes: {
    field: React.PropTypes.object.isRequired,
    form: React.PropTypes.object.isRequired,
    onCancel: React.PropTypes.func.isRequired,
    onRemove: React.PropTypes.func.isRequired,
    onUpdate: React.PropTypes.func.isRequired
  },

  _onUpdate: function (event) {
    event.preventDefault();
    this.props.onUpdate(this.state.field);
  },

  _onChange: function (name) {
    var field = this.state.field;
    field[name] = this.refs[name].getDOMNode().value;
    this.setState({field: field});
  },

  _onToggle: function (name) {
    field = this.state.field;
    field[name] = ! field[name];
    this.setState({field: field});
  },

  _onOptionUpdate: function (option) {
    var field = this.state.field;
    field.formFieldOptions =
      field.formFieldOptions.map(function (formFieldOption) {
        return (formBuilderUtils.idsMatch(option, formFieldOption) ?
          option : formFieldOption);
      });
    this.setState({field: field, newOption: null});
  },

  _onOptionRemove: function (id) {
    var field = this.state.field;
    field.formFieldOptions =
      field.formFieldOptions.filter(function (formFieldOption) {
        return (id !== formBuilderUtils.itemId(formFieldOption));
      });
    this.setState({field: field, newOption: null});
  },

  _onAddOption: function () {
    var field = this.props.field;
    var option = {
      _id: '__' + (new Date()).getTime(),
      name: 'New option',
      optionType: 'fixed'
    };
    field.formFieldOptions.push(option);
    this.setState({field: field, newOption: option});
  },

  _dragStart: function (event) {
    this._dragAndDrop = DragAndDrop.start({
      event: event,
      itemClass: CLASS_ROOT + '__field',
      placeholderClass: PLACEHOLDER_CLASS,
      list: this.state.field.formFieldOptions.slice(0)
    });
  },

  _dragEnd: function (event) {
    var field = this.state.field;
    var options = this._dragAndDrop.end(event);
    options.forEach(function (option, index) {
      option.formFieldIndex = index + 1;
    });
    field.formFieldOptions = options;
    this.setState({field: field});
  },

  _dragOver: function (event) {
    this._dragAndDrop.over(event);
  },

  getInitialState: function () {
    return {field: this.props.field};
  },

  componentDidMount: function () {
    component = this.refs.name || this.refs.help;
    component.getDOMNode().focus();
  },

  render: function () {
    var field = this.props.field;

    var name;
    var help;
    var required;
    var monetary;
    var defaultValue;
    var dependsOnId;
    var unitValue;

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

      var defaultType = ('count' === field.fieldType ? 'number' : 'text');
      var defaultInput = (
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

      dependsOnOptions = [<option key="none"></option>];
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
        var unitValueType = (field.monetary ? 'number' : 'text');
        var unitValueInput = (
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
      }

    } else {

      help = (
        <div className="form__field">
          <textarea ref="help"
            onChange={this._onChange.bind(this, "help")} value={field.help} />
        </div>
      );
    }

    var options;
    if ('single choice' === field.fieldType ||
      'multiple choice' === field.fieldType) {
      var opts = field.formFieldOptions.map(function (option, index) {
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
});

module.exports = FormFieldEditor;
