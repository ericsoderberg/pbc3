import React, { Component, PropTypes } from 'react';
import EditIcon from '../icons/EditIcon';
import Layer from '../../utils/Layer';
import FormFieldEditor from './FormFieldEditor';
import formBuilderUtils from './formBuilderUtils';

var CLASS_ROOT = "form-builder";

export default class FormFieldBuilder extends Component {

  constructor (props) {
    super(props);
    this._onCancelEdit = this._onCancelEdit.bind(this);
    this._onUpdate = this._onUpdate.bind(this);
    this._onRemove = this._onRemove.bind(this);
    this._onEdit = this._onEdit.bind(this);
    this.state = { editOnMount: props.field.hasOwnProperty('_id') };
  }

  componentDidMount () {
    if (this.state.editOnMount) {
      this._onEdit();
      this.setState({ editOnMount: false });
    }
  }

  componentWillUnmount () {
    this._onCancelEdit();
  }

  _onCancelEdit () {
    if (this._layer) {
      this._layer.remove();
      this._layer = null;
    }
  }

  _onUpdate (field) {
    this._onCancelEdit();
    this.props.onUpdate(field);
  }

  _onRemove () {
    this._onCancelEdit();
    this.props.onRemove(formBuilderUtils.itemId(this.props.field));
  }

  _renderEdit () {
    return (
      <FormFieldEditor field={this.props.field}
        form={this.props.form}
        onCancel={this._onCancelEdit}
        onUpdate={this._onUpdate}
        onRemove={this._onRemove} />
    );
  }

  _onEdit () {
    if (this._layer) {
      this._onCancelEdit();
    } else {
      this._layer = Layer.add(this._renderEdit(), 'right');
    }
  }

  render () {
    var field = this.props.field;

    var editControl = (
      <a ref="edit" href="#" className={`${CLASS_ROOT}__field-edit control-icon`}
        onClick={this._onEdit}>
        <EditIcon />
      </a>
    );

    var result = <span></span>;

    if ('instructions' === field.fieldType) {

      result = (
        <div className={`${CLASS_ROOT}__field form__fields-help`}
          data-index={this.props.index}
          draggable="true"
          onDragStart={this.props.dragStart}
          onDragEnd={this.props.dragEnd}>
          <div className={`${CLASS_ROOT}__field-content`}>
            {field.help}
          </div>
          {editControl}
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
              className={`${CLASS_ROOT}__field-option form__field-option`}>
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
        <div className={`${CLASS_ROOT}__field form__field`}
          data-index={this.props.index}
          draggable="true"
          onDragStart={this.props.dragStart}
          onDragEnd={this.props.dragEnd}>
          <div className={`${CLASS_ROOT}__field-content`}>
            {label}
            {help}
            {content}
          </div>
          {editControl}
        </div>
      );
    }

    return result;
  }
};

FormFieldBuilder.propTypes = {
  dragStart: PropTypes.func.isRequired,
  dragEnd: PropTypes.func.isRequired,
  field: PropTypes.object.isRequired,
  form: PropTypes.object.isRequired,
  index: PropTypes.number.isRequired,
  onUpdate: PropTypes.func.isRequired,
  onRemove: PropTypes.func.isRequired
};

module.exports = FormFieldBuilder;
