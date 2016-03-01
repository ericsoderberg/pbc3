import React, { Component, PropTypes } from 'react';
import Menu from '../Menu';
import AddIcon from '../icons/AddIcon';
import EditIcon from '../icons/EditIcon';
import Layer from '../../utils/Layer';
import DragAndDrop from '../../utils/DragAndDrop';
import FormFieldBuilder from './FormFieldBuilder';
import FormSectionEditor from './FormSectionEditor';
import formBuilderUtils from './formBuilderUtils';

const CLASS_ROOT = "form-builder";
const PLACEHOLDER_CLASS = `${CLASS_ROOT}__placeholder`;

const FIELD_TYPES = [
  'single line',
  'multiple lines',
  'single choice',
  'multiple choice',
  'count',
  'instructions'
];

export default class FormSectionBuilder extends Component {

  constructor (props) {
    super(props);
    this.state = {
      section: props.section,
      editOnMount: props.section.hasOwnProperty('_id')
    };
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

  _renderEdit () {
    return (
      <FormSectionEditor section={this.props.section}
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
      this._layer = Layer.add(this._renderEdit());
    }
  }

  _onCancelEdit () {
    if (this._layer) {
      this._layer.remove();
      this._layer = null;
    }
  }

  _onUpdate (section) {
    this._onCancelEdit();
    this.props.onUpdate(section);
  }

  _onRemove () {
    this._onCancelEdit();
    this.props.onRemove(formBuilderUtils.itemId(this.props.section));
  }

  _onAddField (type) {
    const section = this.state.section;
    let field = {
      "_id": `__${(new Date()).getTime()}`,
      fieldType: type
    };
    if ('instructions' === type) {
      field.help = "Something helpful.";
    } else {
      field.name = `New ${type}`;
    }
    if ('single choice' === type || 'multiple choice' === type) {
      field.formFieldOptions = [{
        "_id": `__${(new Date()).getTime()}`,
        name: 'Option 1',
        optionType: 'fixed'
      }];
    }
    section.formFields.push(field);
    this.props.onUpdate(section);
  }

  _onFieldUpdate (field) {
    let section = this.state.section;
    section.formFields = section.formFields.map(formField => {
      return (formBuilderUtils.idsMatch(field, formField) ? field : formField);
    });
    this.props.onUpdate(section);
  }

  _onFieldRemove (id) {
    let section = this.state.section;
    section.formFields = section.formFields.filter(formField => {
      return (id !== formBuilderUtils.itemId(formField));
    });
    this.props.onUpdate(section);
  }

  _dragStart (event) {
    this._dragAndDrop = DragAndDrop.start({
      event: event,
      itemClass: `${CLASS_ROOT}__field`,
      placeholderClass: PLACEHOLDER_CLASS,
      list: this.state.section.formFields.slice(0)
    });
  }

  _dragOver (event) {
    this._dragAndDrop.over(event);
  }

  _dragEnd (event) {
    let section = this.state.section;
    let fields = this._dragAndDrop.end(event);
    fields.forEach(function (field, index) {
      field.formIndex = index + 1;
    });
    section.formFields = fields;
    this.props.onUpdate(section);
  }

  render () {
    const section = this.props.section;

    const editControl = (
      <a ref="edit" href="#"
        className={`${CLASS_ROOT}__section-edit control-icon`}
        onClick={this._onEdit}>
        <EditIcon />
      </a>
    );

    const fields = section.formFields.map(function (formField, index) {
      return (
        <FormFieldBuilder key={formBuilderUtils.itemId(formField)}
          field={formField}
          form={this.props.form}
          onUpdate={this._onFieldUpdate}
          onRemove={this._onFieldRemove}
          index={index}
          dragStart={this._dragStart}
          dragEnd={this._dragEnd} />
      );
    }, this);

    const adds = FIELD_TYPES.map(function (type) {
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
};

FormSectionBuilder.propTypes = {
  dragStart: PropTypes.func.isRequired,
  dragEnd: PropTypes.func.isRequired,
  form: PropTypes.object.isRequired,
  index: PropTypes.number.isRequired,
  onAddSection: PropTypes.func.isRequired,
  onRemove: PropTypes.func.isRequired,
  onUpdate: PropTypes.func.isRequired,
  section: PropTypes.object.isRequired
};
