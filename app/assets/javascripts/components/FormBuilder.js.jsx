var Menu = require('./Menu');
var AddIcon = require('./AddIcon');
var EditIcon = require('./EditIcon');
var CloseIcon = require('./CloseIcon');
var Drop = require('../utils/Drop');
var DragAndDrop = require('../utils/DragAndDrop');
var REST = require('./REST');

var CLASS_ROOT = "form-builder";
var PLACEHOLDER_CLASS = CLASS_ROOT + "__placeholder";

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

function itemId(item) {
  return (item.hasOwnProperty('id') ? item.id : item['_id']);
}

function idsMatch(o1, o2) {
  return ((o1.hasOwnProperty('id') && o2.hasOwnProperty('id') &&
      o1.id === o2.id) ||
    (o1.hasOwnProperty('_id') && o2.hasOwnProperty('_id') &&
      o1['_id'] === o2['_id']));
}

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
      <form className="form form--compact drop">
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

var FormFieldOptionBuilder = React.createClass({

  propTypes: {
    dragEnd: React.PropTypes.func.isRequired,
    dragStart: React.PropTypes.func.isRequired,
    edit: React.PropTypes.bool,
    fieldType: React.PropTypes.string.isRequired,
    index: React.PropTypes.number.isRequired,
    onUpdate: React.PropTypes.func.isRequired,
    onRemove: React.PropTypes.func.isRequired,
    option: React.PropTypes.object.isRequired
  },

  _renderEdit: function () {
    return (
      <FormFieldOptionEditor option={this.props.option}
        onCancel={this._onCancelEdit}
        onUpdate={this._onUpdate}
        onRemove={this._onRemove} />
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

  _onRemove: function () {
    this._onCancelEdit();
    this.props.onRemove(itemId(this.props.option));
  },

  getInitialState: function () {
    return { editOnMount: this.props.edit };
  },

  componentDidMount: function () {
    if (this.state.editOnMount) {
      this._onEdit();
      this.setState({ editOnMount: false });
    }
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
      <div className={CLASS_ROOT + "__field form__field"}
        data-index={this.props.index}
        draggable="true"
        onDragStart={this.props.dragStart}
        onDragEnd={this.props.dragEnd}>
        {editControl}
        <input type={type} />
        {option.name}
        <span className="form__field-option-help">
          {option.help}
        </span>
      </div>
    );
  }
});

function renderDependsOnOptions (field, form) {
  var result = [];
  form.formSections.some(function (formSection) {
    return formSection.formFields.some(function (formField) {
      if (formField.id === field.id) return true;
      result.push(
        <option key={formField.id} label={formField.name} value={formField.id}/>
      );
    });
  });
  return result;
}

var FormFieldEditor = React.createClass({

  propTypes: {
    field: React.PropTypes.object.isRequired,
    form: React.PropTypes.object.isRequired,
    onCancel: React.PropTypes.func.isRequired,
    onChange: React.PropTypes.func.isRequired,
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
    this.setState({field: field}, this.props.onChange);
  },

  _onToggle: function (name) {
    field = this.state.field;
    field[name] = ! field[name];
    this.setState({field: field}, this.props.onChange);
  },

  _onOptionUpdate: function (option) {
    var field = this.state.field;
    field.formFieldOptions =
      field.formFieldOptions.map(function (formFieldOption) {
        return (idsMatch(option, formFieldOption) ? option : formFieldOption);
      });
    this.setState({field: field, newOption: null}, this.props.onChange);
  },

  _onOptionRemove: function (id) {
    var field = this.state.field;
    field.formFieldOptions =
      field.formFieldOptions.filter(function (formFieldOption) {
        return (id !== itemId(formFieldOption));
      });
    this.setState({field: field, newOption: null}, this.props.onChange);
  },

  _onAddOption: function () {
    var field = this.props.field;
    var option = {
      _id: '__' + (new Date()).getTime(),
      name: 'New option',
      optionType: 'fixed'
    };
    field.formFieldOptions.push(option);
    this.setState({field: field, newOption: option}, this.props.onChange);
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
    this.setState({field: field}, this.props.onChange);
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

      if (true || 'single choice' !== field.fieldType &&
        'multiple choice' !== field.fieldType) {
        defaultValue = (
          <div className="form__field">
            <label>Default value</label>
            <input ref="value" type="text"
              onChange={this._onChange.bind(this, "value")} value={field.value} />
          </div>
        );
      }

      dependsOnOptions = [<option></option>];
      this.props.form.formSections.some(function (formSection) {
        return formSection.formFields.some(function (formField) {
          if (formField.id === field.id) return true;
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
            <select ref="dependsOnId" value={field.dependsOnId}
              onChange={this._onChange.bind(this, "dependsOnId")}>
              {dependsOnOptions}
            </select>
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
          <FormFieldOptionBuilder key={itemId(option)}
            fieldType={field.fieldType}
            option={option} onUpdate={this._onOptionUpdate}
            onRemove={this._onOptionRemove}
            edit={option === this.state.newOption}
            index={index}
            dragStart={this._dragStart}
            dragEnd={this._dragEnd} />
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
      <form className="form form--compact drop">
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

var FormFieldBuilder = React.createClass({

  propTypes: {
    dragStart: React.PropTypes.func.isRequired,
    dragEnd: React.PropTypes.func.isRequired,
    field: React.PropTypes.object.isRequired,
    form: React.PropTypes.object.isRequired,
    index: React.PropTypes.number.isRequired,
    onUpdate: React.PropTypes.func.isRequired,
    onRemove: React.PropTypes.func.isRequired
  },

  _renderEdit: function () {
    return (
      <FormFieldEditor field={this.props.field}
        form={this.props.form}
        onCancel={this._onCancelEdit}
        onChange={this._onEditChange}
        onUpdate={this._onUpdate}
        onRemove={this._onRemove} />
    );
  },

  _onEdit: function () {
    if (this._drop) {
      this._onCancelEdit();
    } else {
      this._drop = Drop.add(this.refs.edit.getDOMNode(),
        this._renderEdit(), {top: 'top', right: 'right'});
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

  _onRemove: function () {
    this._onCancelEdit();
    this.props.onRemove(itemId(this.props.field));
  },

  _onEditChange: function () {
    this._drop.place();
  },

  getInitialState: function () {
    return { editOnMount: this.props.field.hasOwnProperty('_id') };
  },

  componentDidMount: function () {
    if (this.state.editOnMount) {
      this._onEdit();
      this.setState({ editOnMount: false });
    }
  },

  componentWillUnmount: function () {
    this._onCancelEdit();
  },

  render: function () {
    var field = this.props.field;

    var editControl = (
      <a ref="edit" href="#" className={CLASS_ROOT + "__field-edit control-icon"}
        onClick={this._onEdit}>
        <EditIcon />
      </a>
    );

    var result = <span></span>;

    if ('instructions' === field.fieldType) {

      result = (
        <div className={CLASS_ROOT + "__field form__fields_help"}
          data-index={this.props.index}
          draggable="true"
          onDragStart={this.props.dragStart}
          onDragEnd={this.props.dragEnd}>
          {editControl}
          {field.help}
        </div>
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
        var content = field.formFieldOptions.map(function (option) {
          return (
            <div key={itemId(option)} className={CLASS_ROOT + "__field-option"}>
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
            <div key={itemId(option)} className={CLASS_ROOT + "__field-option"}>
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
        <div className={CLASS_ROOT + "__field form__field"}
          data-index={this.props.index}
          draggable="true"
          onDragStart={this.props.dragStart}
          onDragEnd={this.props.dragEnd}>
          {editControl}
          {label}
          {help}
          {content}
        </div>
      );
    }

    return result;
  }
});

var FormSectionEditor = React.createClass({

  propTypes: {
    form: React.PropTypes.object.isRequired,
    onCancel: React.PropTypes.func.isRequired,
    onChange: React.PropTypes.func.isRequired,
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
    this.setState({section: section}, this.props.onChange);
  },

  _onToggle: function (name) {
    section = this.state.section;
    section[name] = ! section[name];
    this.setState({section: section}, this.props.onChange);
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
    var dependsOnOptions = [<option></option>];
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

var FormSectionBuilder = React.createClass({

  propTypes: {
    dragStart: React.PropTypes.func.isRequired,
    dragEnd: React.PropTypes.func.isRequired,
    form: React.PropTypes.object.isRequired,
    index: React.PropTypes.number.isRequired,
    onAddSection: React.PropTypes.func.isRequired,
    onRemove: React.PropTypes.func.isRequired,
    onUpdate: React.PropTypes.func.isRequired,
    section: React.PropTypes.object.isRequired
  },

  _renderEdit: function () {
    return (
      <FormSectionEditor section={this.props.section}
        form={this.props.form}
        onCancel={this._onCancelEdit}
        onChange={this._onEditChange}
        onUpdate={this._onUpdate}
        onRemove={this._onRemove} />
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

  _onUpdate: function (section) {
    this._onCancelEdit();
    this.props.onUpdate(section);
  },

  _onRemove: function () {
    this._onCancelEdit();
    this.props.onRemove(itemId(this.props.section));
  },

  _onEditChange: function () {
    this._drop.place();
  },

  _onAddField: function (type) {
    var section = this.state.section;
    var field = {
      "_id": '__' + (new Date()).getTime(),
      fieldType: type
    };
    if ('instructions' === type) {
      field.help = "Something helpful.";
    } else {
      field.name = 'New ' + type;
    }
    if ('single choice' === type || 'multiple choice' === type) {
      field.formFieldOptions = [{
        "_id": '__' + (new Date()).getTime(),
        name: 'Option 1',
        optionType: 'fixed'
      }];
    }
    section.formFields.push(field);
    this.props.onUpdate(section);
  },

  _onFieldUpdate: function (field) {
    var section = this.state.section;
    section.formFields = section.formFields.map(function (formField) {
      return (idsMatch(field, formField) ? field : formField);
    });
    this.props.onUpdate(section);
  },

  _onFieldRemove: function (id) {
    var section = this.state.section;
    section.formFields = section.formFields.filter(function (formField) {
      return (id !== itemId(formField));
    });
    this.props.onUpdate(section);
  },

  _dragStart: function (event) {
    this._dragAndDrop = DragAndDrop.start({
      event: event,
      itemClass: CLASS_ROOT + '__field',
      placeholderClass: PLACEHOLDER_CLASS,
      list: this.state.section.formFields.slice(0)
    });
  },

  _dragOver: function (event) {
    this._dragAndDrop.over(event);
  },

  _dragEnd: function (event) {
    var section = this.state.section;
    var fields = this._dragAndDrop.end(event);
    fields.forEach(function (field, index) {
      field.formIndex = index + 1;
    });
    section.formFields = fields;
    this.props.onUpdate(section);
  },

  getInitialState: function () {
    return {
      section: this.props.section,
      editOnMount: this.props.section.hasOwnProperty('_id')
    };
  },

  componentDidMount: function () {
    if (this.state.editOnMount) {
      this._onEdit();
      this.setState({ editOnMount: false });
    }
  },

  componentWillUnmount: function () {
    this._onCancelEdit();
  },

  render: function () {
    var section = this.props.section;

    var editControl = (
      <a ref="edit" href="#" className={CLASS_ROOT + "__section-edit control-icon"}
        onClick={this._onEdit}>
        <EditIcon />
      </a>
    );

    var fields = section.formFields.map(function (formField, index) {
      return (
        <FormFieldBuilder key={itemId(formField)}
          field={formField}
          form={this.props.form}
          onUpdate={this._onFieldUpdate}
          onRemove={this._onFieldRemove}
          index={index}
          dragStart={this._dragStart}
          dragEnd={this._dragEnd} />
      );
    }, this);

    var adds = FIELD_TYPES.map(function (type) {
      return (
        <a key={type} href="#" onClick={this._onAddField.bind(this, type)}>
          {type}
        </a>
      );
    }, this);
    adds.push(
      <a key="section" href="#" onClick={this.props.onAddSection}>section</a>
    );

    return (
      <fieldset className={CLASS_ROOT + "__section"}
        data-index={this.props.index}
        draggable="true"
        onDragStart={this.props.dragStart}
        onDragEnd={this.props.dragEnd}>
        <legend className={CLASS_ROOT + "__section-header"}>
          {editControl}
          <h2>{section.name}</h2>
        </legend>
        <div className="form__fields" onDragOver={this._dragOver}>
          {fields}
        </div>
        <Menu className={CLASS_ROOT + "__add"} icon={<AddIcon />}>
          {adds}
        </Menu>
      </fieldset>
    );
  }
});

var FormBuilder = React.createClass({

  propTypes: {
    editContents: React.PropTypes.object.isRequired
  },

  _onSubmit: function (event) {
    event.preventDefault();
    var url = this.props.editContents.updateUrl;
    var token = this.props.editContents.authenticityToken;
    var data = {
      form: this.state.form
    };
    if (this.props.editContents.pageId) {
      data.pageId = this.props.editContents.pageId;
    }
    console.log('!!! FormBuilder _onSubmit', token, this.state.form);
    REST.post(url, token, data, function (response) {
      console.log('!!! FormBuilder _onSubmit completed', response);
      if (response.result === 'ok') {
        location = response.redirect_to;
      }
    }.bind(this));
  },

  _dragStart: function (event) {
    this._dragAndDrop = DragAndDrop.start({
      event: event,
      itemClass: CLASS_ROOT + '__section',
      placeholderClass: PLACEHOLDER_CLASS,
      list: this.state.form.formSections.slice(0)
    });
  },

  _dragOver: function (event) {
    this._dragAndDrop.over(event);
  },

  _dragEnd: function (event) {
    var form = this.state.form;
    var sections = this._dragAndDrop.end(event);
    sections.forEach(function (section, index) {
      section.formIndex = index + 1;
    });
    form.formSections = sections;
    this.setState({form: form});
  },

  _onAddSection: function () {
    var form = this.state.form;
    var section = {
      "_id": '__' + (new Date()).getTime(),
      name: "New section",
      formFields: []
    };
    form.formSections.push(section);
    this.setState({form: form});
  },

  _onSectionUpdate: function (section) {
    var form = this.state.form;
    form.formSections = form.formSections.map(function (formSection) {
      return (idsMatch(section, formSection) ? section : formSection);
    });
    this.setState({form: form});
  },

  _onSectionRemove: function (id) {
    var form = this.state.form;
    form.formSections = form.formSections.filter(function (formSection) {
      return (id !== itemId(formSection));
    });
    this.setState({form: form});
  },

  getInitialState: function () {
    return {form: this.props.editContents.form};
  },

  render: function () {
    var form = this.state.form;
    var sections = form.formSections.map(function (formSection, index) {
      return (
        <FormSectionBuilder key={itemId(formSection)}
          section={formSection}
          form={form}
          onUpdate={this._onSectionUpdate}
          onRemove={this._onSectionRemove}
          onAddSection={this._onAddSection}
          index={index}
          dragStart={this._dragStart}
          dragEnd={this._dragEnd} />
      );
    }, this);

    return (
      <form className="form">
        <div className="form__header">
          <span className="form__title">Edit {form.name}</span>
          <a className="control-icon" href={this.props.editContents.cancelUrl}>
            <CloseIcon />
          </a>
        </div>

        <div className="form__contents">
          <div className={CLASS_ROOT}>
            <div className={CLASS_ROOT + "__sections"}
              onDragOver={this._dragOver}>
              {sections}
            </div>
          </div>
        </div>

        <div className="form__footer">
          <input type="submit" value="Update" className="btn btn--primary"
            onClick={this._onSubmit} />
          <a href={this.props.editContents.editContextUrl}>
            Context
          </a>
        </div>
      </form>
    );
  }
});

module.exports = FormBuilder;
