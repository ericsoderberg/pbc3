var Menu = require('../Menu');
var AddIcon = require('../icons/AddIcon');
var EditIcon = require('../icons/EditIcon');
var Layer = require('../../utils/Layer');
var DragAndDrop = require('../../utils/DragAndDrop');
var FormFieldBuilder = require('./FormFieldBuilder');
var FormSectionEditor = require('./FormSectionEditor');

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

function itemId(item) {
  return (item.hasOwnProperty('id') ? item.id : item['_id']);
}

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
        onUpdate={this._onUpdate}
        onRemove={this._onRemove} />
    );
  },

  _onEdit: function () {
    if (this._layer) {
      this._onCancelEdit();
    } else {
      this._layer = Layer.add(this._renderEdit());
    }
  },

  _onCancelEdit: function () {
    if (this._layer) {
      this._layer.remove();
      this._layer = null;
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

module.exports = FormSectionBuilder;
