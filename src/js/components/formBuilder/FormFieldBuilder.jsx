import React, { Component, PropTypes } from 'react';
import EditIconfrom '../icons/EditIcon');
import Layerfrom '../../utils/Layer');
import FormFieldEditorfrom './FormFieldEditor');
import formBuilderUtilsfrom './formBuilderUtils');

var CLASS_ROOT = "form-builder";

var FormFieldBuilderextends Component {

  propTypes: {
    dragStart: PropTypes.func.isRequired,
    dragEnd: PropTypes.func.isRequired,
    field: PropTypes.object.isRequired,
    form: PropTypes.object.isRequired,
    index: PropTypes.number.isRequired,
    onUpdate: PropTypes.func.isRequired,
    onRemove: PropTypes.func.isRequired
  },

  _renderEdit () {
    return (
      <FormFieldEditor field={this.props.field}
        form={this.props.form}
        onCancel={this._onCancelEdit}
        onUpdate={this._onUpdate}
        onRemove={this._onRemove} />
    );
  },

  _onEdit () {
    if (this._layer) {
      this._onCancelEdit();
    } else {
      this._layer = Layer.add(this._renderEdit(), 'right');
    }
  },

  _onCancelEdit () {
    if (this._layer) {
      this._layer.remove();
      this._layer = null;
    }
  },

  _onUpdate (field) {
    this._onCancelEdit();
    this.props.onUpdate(field);
  },

  _onRemove () {
    this._onCancelEdit();
    this.props.onRemove(formBuilderUtils.itemId(this.props.field));
  },

  getInitialState () {
    return { editOnMount: this.props.field.hasOwnProperty('_id') };
  },

  componentDidMount () {
    if (this.state.editOnMount) {
      this._onEdit();
      this.setState({ editOnMount: false });
    }
  },

  componentWillUnmount () {
    this._onCancelEdit();
  },

  render () {
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
