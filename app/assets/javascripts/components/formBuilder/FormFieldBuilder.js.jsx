var EditIcon = require('../icons/EditIcon');
var Layer = require('../../utils/Layer');
var FormFieldEditor = require('./FormFieldEditor');
var formBuilderUtils = require('./formBuilderUtils');

var CLASS_ROOT = "form-builder";

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
    this.props.onRemove(formBuilderUtils.itemId(this.props.field));
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
        if (field.monetary) {
          content = (
            <div className="form__field-decorated-input">${content}</div>
          );
        }
      } else if ('multiple lines' === field.fieldType) {
        content = <textarea defaultValue={field.value} />;
      } else if ('single choice' === field.fieldType ||
        'multiple choice' === field.fieldType) {
        var type = 'multiple choice' === field.fieldType ? 'checkbox' : 'radio';
        var content = field.formFieldOptions.map(function (option) {
          var value;
          if (option.value) {
            var prefix = field.monetary ? '$' : '';
            value = (
              <span className="form__field-option-suffix">
                {prefix}{option.value}
              </span>
            );
          }
          return (
            <div key={formBuilderUtils.itemId(option)}
              className={CLASS_ROOT + "__field-option form__field-option"}>
              <span>
                <input type={type} />
                {option.name}
              </span>
              <span className="form__field-option-help">
                {option.help}
              </span>
              {value}
            </div>
          );
        });
      } else if ('count' === field.fieldType) {
        var suffix = 'x ' + (field.monetary ? '$' : '') + field.unitValue;
        content = (
          <div className="form__field-decorated-input">
            <input type="number" defaultValue={field.value} />
            <span className="form__field-decorated-input-suffix">{suffix}</span>
          </div>
        );
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
