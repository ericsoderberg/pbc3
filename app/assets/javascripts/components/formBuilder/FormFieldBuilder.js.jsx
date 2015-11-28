var EditIcon = require('../icons/EditIcon');
var Layer = require('../../utils/Layer');
var FormFieldEditor = require('./FormFieldEditor');

var CLASS_ROOT = "form-builder";

function itemId(item) {
  return (item.hasOwnProperty('id') ? item.id : item['_id']);
}

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
        onUpdate={this._onUpdate}
        onRemove={this._onRemove} />
    );
  },

  _onEdit: function () {
    if (this._layer) {
      this._onCancelEdit();
    } else {
      this._layer = Layer.add(this._renderEdit(), 'right');
    }
  },

  _onCancelEdit: function () {
    if (this._layer) {
      this._layer.remove();
      this._layer = null;
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
        content = <input type="text" defaultValue={field.value} />;
      } else if ('multiple lines' === field.fieldType) {
        content = <textarea defaultValue={field.value} />;
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
        content = <input type="number" defaultValue={field.value} />;
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

module.exports = FormFieldBuilder;
