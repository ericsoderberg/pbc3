import React, { Component, PropTypes } from 'react';
import EditIcon from '../icons/EditIcon';
import Layer from '../../utils/Layer';
import FormFieldOptionEditor from './FormFieldOptionEditor';
import formBuilderUtils from './formBuilderUtils';

var CLASS_ROOT = "form-builder";

export default class FormFieldOptionBuilder extends Component {

  constructor (props) {
    super(props);
    this._onCancelEdit = this._onCancelEdit.bind(this);
    this._onUpdate = this._onUpdate.bind(this);
    this._onRemove = this._onRemove.bind(this);
    this._onEdit = this._onEdit.bind(this);
    this.state = { editOnMount: props.edit };
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

  _onUpdate (option) {
    this._onCancelEdit();
    this.props.onUpdate(option);
  }

  _onRemove () {
    this._onCancelEdit();
    this.props.onRemove(formBuilderUtils.itemId(this.props.option));
  }

  _renderEdit () {
    return (
      <FormFieldOptionEditor option={this.props.option}
        onCancel={this._onCancelEdit}
        onUpdate={this._onUpdate}
        onRemove={this._onRemove}
        monetary={this.props.monetary} />
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
    const type = ('single choice' === this.props.fieldType ? 'radio' : 'checkbox');
    const option = this.props.option;

    const editControl = (
      <a ref="edit" href="#" className={`${CLASS_ROOT}__field-edit control-icon`}
        onClick={this._onEdit}>
        <EditIcon />
      </a>
    );

    var value;
    if (option.value) {
      var prefix = this.props.monetary ? '$' : '';
      value = (
        <span className="form__field-option-suffix">
          {prefix}{option.value}
        </span>
      );
    }

    return (
      <div className={`${CLASS_ROOT}__field form__field`}
        data-index={this.props.index}
        draggable="true"
        onDragStart={this.props.dragStart}
        onDragEnd={this.props.dragEnd}>
        {editControl}
        <div className="form__field-option">
          <span>
            <input type={type} />
            {option.name}
          </span>
          <span className="form__field-option-help">
            {option.help}
          </span>
          {value}
        </div>
      </div>
    );
  }
};

FormFieldOptionBuilder.propTypes = {
  dragEnd: PropTypes.func.isRequired,
  dragStart: PropTypes.func.isRequired,
  edit: PropTypes.bool,
  fieldType: PropTypes.string.isRequired,
  index: PropTypes.number.isRequired,
  monetary: PropTypes.bool,
  onUpdate: PropTypes.func.isRequired,
  onRemove: PropTypes.func.isRequired,
  option: PropTypes.object.isRequired
};
