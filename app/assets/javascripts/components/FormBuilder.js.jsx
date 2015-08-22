var Menu = require('./Menu');
var AddIcon = require('./AddIcon');
var EditIcon = require('./EditIcon');
var CloseIcon = require('./CloseIcon');
var Drop = require('../utils/Drop');

var CLASS_ROOT = "form-builder";

var FIELD_TYPES = [
  'single line',
  'multiple lines',
  'single choice',
  'multiple choice',
  'count',
  'instructions'
];

var OPTION_TYPES = [
  'fixed',
  'single line',
  'multiple lines',
  'instructions'
];

var FormFieldOptionEditor = React.createClass({

  propTypes: {
    option: React.PropTypes.object.isRequired,
    onCancel: React.PropTypes.func.isRequired,
    onDelete: React.PropTypes.func.isRequired,
    onUpdate: React.PropTypes.func.isRequired
  },

  getInitialState: function () {
    return {option: this.props.option};
  },

  _onUpdate: function () {
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

  render: function () {
    var option = this.props.option;

    return (
      <form className="form form--compact drop">
        <div className="form__header">
          <span className="form__title">Edit Option</span>
          <a href="#" className="control-icon" onClick={this.props.onCancel}>
            <CloseIcon />
          </a>
        </div>
        <div className="form__contents">
          <fieldset>
            <ul className="form__fields list-bare">
              <li className="form__field">
                <label>Name</label>
                <input ref="name" type="text"
                  onChange={this._onChange.bind(this, "name")} value={option.name} />
              </li>
              <li className="form__field">
                <label>Help</label>
                <input ref="help" type="text"
                  onChange={this._onChange.bind(this, "help")} value={option.help} />
              </li>
            </ul>
          </fieldset>
        </div>
        <div className="form__footer">
          <button className="btn btn--primary" onClick={this._onUpdate}>Update</button>
          <a href="#" onClick={this.props.onDelete}>Delete</a>
        </div>
      </form>
    );
  }
});

var FormFieldOptionBuilder = React.createClass({

  propTypes: {
    fieldType: React.PropTypes.string.isRequired,
    option: React.PropTypes.object.isRequired,
    onUpdate: React.PropTypes.func.isRequired,
    onDelete: React.PropTypes.func.isRequired
  },

  _renderEdit: function () {
    return (
      <FormFieldOptionEditor option={this.props.option}
        onCancel={this._onCancelEdit}
        onUpdate={this._onUpdate}
        onDelete={this._onDelete} />
    );
  },

  _onEdit: function () {
    if (this._drop) {
      this._onCancelEdit();
    } else {
      this._drop = Drop.add(this.refs.edit.getDOMNode(),
        this._renderEdit(), {top: 'top', right: 'left'});
    }
  },

  _onCancelEdit: function () {
    if (this._drop) {
      this._drop.remove();
      this._drop = null;
    }
  },

  _onUpdate: function (option) {
    this._onCancelEdit();
    this.props.onUpdate(option);
  },

  _onDelete: function () {
    this._onCancelEdit();
    this.props.onDelete(this.props.option.id);
  },

  componentWillUnmount: function () {
    this._onCancelEdit();
  },

  render: function () {
    var type = ('single choice' === this.props.fieldType ? 'radio' : 'checkbox');
    var option = this.props.option;

    var editControl = (
      <a ref="edit" href="#" className={CLASS_ROOT + "__field-edit control-icon"}
        onClick={this._onEdit}>
        <EditIcon />
      </a>
    );

    return (
      <li className="form__field">
        {editControl}
        <input type={type} />
        {option.name}
        <span className="form__field-option-help">
          {option.help}
        </span>
      </li>
    );
  }
});

var FormFieldEditor = React.createClass({

  propTypes: {
    field: React.PropTypes.object.isRequired,
    onCancel: React.PropTypes.func.isRequired,
    onChange: React.PropTypes.func.isRequired,
    onDelete: React.PropTypes.func.isRequired,
    onUpdate: React.PropTypes.func.isRequired
  },

  getInitialState: function () {
    return {field: this.props.field};
  },

  _onUpdate: function () {
    this.props.onUpdate(this.state.field);
  },

  _onChange: function (name) {
    var field = this.state.field;
    field[name] = this.refs[name].getDOMNode().value;
    this.setState({field: field}, this.props.onChange);
  },

  _onToggle: function (name) {
    field = this.state.field;
    field[name] = ! field[name];
    this.setState({field: field}, this.props.onChange);
  },

  _onOptionUpdate: function (option) {
    var field = this.state.field;
    field.formFieldOptions = field.formFieldOptions.map(function (formFieldOption) {
      return (option.id === formFieldOption.id ? option : formFieldOption);
    });
    this.setState({field: field}, this.props.onChange);
  },

  _onOptionDelete: function (id) {
    var field = this.state.field;
    field.formFieldOptions = field.formFieldOptions.filter(function (formFieldOption) {
      return (id !== formFieldOption.id);
    });
    this.setState({field: field}, this.props.onChange);
  },

  _onAddOption: function () {
    var field = this.props.field;
    var option = {
      id: '__' + (new Date()).getTime(),
      name: 'New option',
      optionType: 'fixed'
    };
    field.formFieldOptions.push(option);
    this.setState({field: field}, this.props.onChange);
  },

  render: function () {
    var field = this.props.field;

    var name;
    var help;
    var required;
    var monetary;

    if ('instructions' !== field.fieldType) {

      name = (
        <li className="form__field">
          <label>Name</label>
          <input ref="name" type="text"
            onChange={this._onChange.bind(this, "name")} value={field.name} />
        </li>
      );

      help = (
        <li className="form__field">
          <label>Help</label>
          <input ref="help" type="text"
            onChange={this._onChange.bind(this, "help")} value={field.help} />
        </li>
      );

      required = (
        <li className="form__field">
          <label>Required</label>
          <input ref="required" type="checkbox"
            onChange={this._onToggle.bind(this, "required")}
            checked={field.required} />
        </li>
      );

      monetary = (
        <li className="form__field">
          <label>Monetary</label>
          <input ref="monetary" type="checkbox"
            onChange={this._onToggle.bind(this, "monetary")}
            checked={field.monetary} />
        </li>
      );

    } else {
      help = (
        <li className="form__field">
          <textarea ref="help"
            onChange={this._onChange.bind(this, "help")} value={field.help} />
        </li>
      );
    }

    var options;
    if ('single choice' === field.fieldType || 'multiple choice' === field.fieldType) {
      var opts = field.formFieldOptions.map(function (option) {
        return (
          <FormFieldOptionBuilder key={option.id} fieldType={field.fieldType}
            option={option} onUpdate={this._onOptionUpdate}
            onDelete={this._onOptionDelete} />
        );
      }, this);
      options = (
        <fieldset>
          <legend>Options</legend>
          <ul className="form__fields list-bare">
            {opts}
          </ul>
          <a className={CLASS_ROOT + "__add control-icon"} onClick={this._onAddOption}>
            <AddIcon />
          </a>
        </fieldset>
      );
    }

    return (
      <form className="form form--compact drop">
        <div className="form__header">
          <span className="form__title">Edit {field.fieldType}</span>
          <a href="#" className="control-icon" onClick={this.props.onCancel}>
            <CloseIcon />
          </a>
        </div>
        <div className="form__contents">
          <fieldset>
            <ul className="form__fields list-bare">
              {name}
              {help}
              {required}
              {monetary}
            </ul>
          </fieldset>
          {options}
        </div>
        <div className="form__footer">
          <button className="btn btn--primary" onClick={this._onUpdate}>Update</button>
          <a href="#" onClick={this.props.onDelete}>Delete</a>
        </div>
      </form>
    );
  }
});

var FormFieldBuilder = React.createClass({

  propTypes: {
    dragStart: React.PropTypes.func.isRequired,
    dragEnd: React.PropTypes.func.isRequired,
    field: React.PropTypes.object.isRequired,
    index: React.PropTypes.number.isRequired,
    onUpdate: React.PropTypes.func.isRequired,
    onDelete: React.PropTypes.func.isRequired
  },

  _renderEdit: function () {
    return (
      <FormFieldEditor field={this.props.field}
        onCancel={this._onCancelEdit}
        onChange={this._onEditChange}
        onUpdate={this._onUpdate}
        onDelete={this._onDelete} />
    );
  },

  _onEdit: function () {
    if (this._drop) {
      this._onCancelEdit();
    } else {
      this._drop = Drop.add(this.refs.edit.getDOMNode(),
        this._renderEdit(), {top: 'top', right: 'left'});
    }
  },

  _onCancelEdit: function () {
    if (this._drop) {
      this._drop.remove();
      this._drop = null;
    }
  },

  _onUpdate: function (field) {
    this._onCancelEdit();
    this.props.onUpdate(field);
  },

  _onDelete: function () {
    this._onCancelEdit();
    this.props.onDelete(this.props.field.id);
  },

  _onEditChange: function () {
    this._drop.place();
  },

  componentWillUnmount: function () {
    this._onCancelEdit();
  },

  render: function () {
    var field = this.props.field;

    var editControl = (
      <a ref="edit" href="#" className="form__field-edit control-icon" onClick={this._onEdit}>
        <EditIcon />
      </a>
    );

    var result = <span></span>;

    if ('instructions' === field.fieldType) {

      result = (
        <li className={CLASS_ROOT + "__field form__fields_help"}
          data-index={this.props.index}
          draggable="true"
          onDragStart={this.props.dragStart}
          onDragEnd={this.props.dragEnd}>
          {editControl}
          {field.help}
        </li>
      );

    } else {

      var label;
      if (field.name) {
        label = <label>{field.name}</label>;
      }

      var help;
      if (field.help) {
        help = <div className="form__field-help">{field.help}</div>;
      }

      var content;
      if ('single line' === field.fieldType) {
        content = <input type="text" value={field.value} />;
      } else if ('multiple lines' === field.fieldType) {
        content = <textarea value={field.value} />;
      } else if ('single choice' === field.fieldType) {
        /*var options = field.formFieldOptions.map(function (option) {
          return <option>{option.name}</option>;
        });
        content = (
          <select>
            {options}
          </select>
        );*/
        var content = field.formFieldOptions.map(function (option) {
          return (
            <div key={option.id} className={CLASS_ROOT + "__field-option"}>
              <input type="radio" />
              {option.name}
              <span className="form__field-option-help">
                {option.help}
              </span>
            </div>
          );
        });
      } else if ('multiple choice' === field.fieldType) {
        var content = field.formFieldOptions.map(function (option) {
          return (
            <div key={option.id} className={CLASS_ROOT + "__field-option"}>
              <input type="checkbox" />
              {option.name}
              <span className="form__field-option-help">
                {option.help}
              </span>
            </div>
          );
        });
      } else if ('count' === field.fieldType) {
        content = <input type="number" value={field.value} />;
      }

      result = (
        <li className={CLASS_ROOT + "__field form__field"}
          data-index={this.props.index}
          draggable="true"
          onDragStart={this.props.dragStart}
          onDragEnd={this.props.dragEnd}>
          {editControl}
          {label}
          {help}
          {content}
        </li>
      );
    }

    return result;
  }
});

var FormSectionBuilder = React.createClass({

  propTypes: {
    onUpdate: React.PropTypes.func.isRequired,
    section: React.PropTypes.object.isRequired
  },

  getInitialState: function () {
    return {section: this.props.section};
  },

  _onFieldUpdate: function (field) {
    var section = this.state.section;
    section.formFields = section.formFields.map(function (formField) {
      return (field.id === formField.id ? field : formField);
    });
    this.props.onUpdate(section);
  },

  _onFieldDelete: function (id) {
    var section = this.state.section;
    section.formFields = section.formFields.filter(function (formField) {
      return (id !== formField.id);
    });
    this.props.onUpdate(section);
  },

  // http://webcloud.se/sortable-list-component-react-js/

  _dragStart: function (event) {
    this._dragged = event.currentTarget;
    event.dataTransfer.effectAllowed = 'move';

    // Firefox requires calling dataTransfer.setData
    // for the drag to properly work
    event.dataTransfer.setData("text/html", event.currentTarget);

    this._placeholder = document.createElement("li");
    this._placeholder.className = "placeholder";
  },

  _dragEnd: function (event) {
    var placeholder = this._placeholder;
    this._dragged.style.display = "block";
    this._dragged.parentNode.removeChild(placeholder);

    // Update state
    var section = this.state.section;
    var formFields = section.formFields;
    var from = Number(this._dragged.dataset.index);
    var to = Number(this._over.dataset.index);
    if (from < to) to--;
    formFields.splice(to, 0, formFields.splice(from, 1)[0]);
    section.formFields = formFields;
    this.setState({section: section});
  },

  _dragOver: function (event) {
    event.preventDefault();
    var placeholder = this._placeholder;
    this._dragged.style.display = "none";
    var element = event.target;
    // find containing element
    while (!element.classList.contains(CLASS_ROOT + '__field') &&
      (element = element.parentElement));
    if (element && element.className !== "placeholder") {
      this._over = element;
      element.parentNode.insertBefore(placeholder, element);
    }
  },

  render: function () {
    var section = this.props.section;
    var fields = section.formFields.map(function (formField, index) {
      return (
        <FormFieldBuilder key={formField.id} field={formField}
          onUpdate={this._onFieldUpdate}
          onDelete={this._onFieldDelete}
          index={index}
          dragStart={this._dragStart}
          dragEnd={this._dragEnd} />
      );
    }, this);

    return (
      <fieldset className={CLASS_ROOT + "__section"}>
        <ul className="form__fields list-bare" onDragOver={this._dragOver}>
          {fields}
        </ul>
      </fieldset>
    );
  }
});

var FormBuilder = React.createClass({

  // http://webcloud.se/sortable-list-component-react-js/

  _dragStart: function (event) {
    this._dragged = event.currentTarget;
    event.dataTransfer.effectAllowed = 'move';

    // Firefox requires calling dataTransfer.setData
    // for the drag to properly work
    event.dataTransfer.setData("text/html", event.currentTarget);

    this._placeholder = document.createElement("li");
    this._placeholder.className = "placeholder";
  },

  _dragEnd: function (event) {
    var placeholder = this._placeholder;
    this._dragged.style.display = "block";
    this._dragged.parentNode.removeChild(placeholder);

    // Update state
    var form = this.state.form;
    var sections = form.sections;
    var from = Number(this._dragged.dataset.index);
    var to = Number(this._over.dataset.index);
    if (from < to) to--;
    sections.splice(to, 0, sections.splice(from, 1)[0]);
    form.sections = sections;
    this.setState({form: form});
  },

  _dragOver: function (event) {
    event.preventDefault();
    var placeholder = this._placeholder;
    this._dragged.style.display = "none";
    var element = event.target;
    // find containing element
    while (!element.classList.contains(CLASS_ROOT + '__section') &&
      (element = element.parentElement));
    if (element && element.className !== "placeholder") {
      this._over = element;
      element.parentNode.insertBefore(placeholder, element);
    }
  },

  _onAddField: function (type) {
    var form = this.state.form;
    var field = {
      id: '__' + (new Date()).getTime(),
      fieldType: type
    };
    if ('instructions' === type) {
      field.help = "Something helpful.";
    } else {
      field.name = 'New ' + type;
    }
    if ('single choice' === type || 'multiple choice' === type) {
      field.formFieldOptions = [{
        id: '__' + (new Date()).getTime(),
        name: 'Option 1',
        optionType: 'fixed'
      }];
    }
    form.formSections[0].formFields.push(field);
    this.setState({form: form});
  },

  getInitialState: function () {
    return {form: this.props.editContents.form};
  },

  _onSectionUpdate: function (section) {
    var form = this.state.form;
    form.formSections = form.formSections.map(function (formSection) {
      return (section.id === formSection.id ? section : formSection);
    });
    this.setState({form: form});
  },

  render: function () {
    var form = this.state.form;
    var sections = form.formSections.map(function (formSection) {
      return (
        <FormSectionBuilder key={formSection.id} section={formSection}
          onUpdate={this._onSectionUpdate} />
      );
    }, this);

    var adds = FIELD_TYPES.map(function (type) {
      return <a key={type} href="#" onClick={this._onAddField.bind(this, type)}>{type}</a>
    }, this);

    /*
        <ol className={CLASS_ROOT + "__sections list-bare"}
          onDragOver={this._dragOver}>
          {sections}
        </ol>
    */

    return (
      <div className={CLASS_ROOT}>
        <ol className={CLASS_ROOT + "__sections list-bare"}>
          {sections}
        </ol>

        <Menu className={CLASS_ROOT + "__add"} icon={<AddIcon />}>
          {adds}
        </Menu>
      </div>
    );
  }
});

module.exports = FormBuilder;
