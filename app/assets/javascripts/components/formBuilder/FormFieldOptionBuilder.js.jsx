var EditIcon = require('../icons/EditIcon');
var Layer = require('../../utils/Layer');
var FormFieldOptionEditor = require('./FormFieldOptionEditor');

var CLASS_ROOT = "form-builder";

function itemId(item) {
  return (item.hasOwnProperty('id') ? item.id : item['_id']);
}

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

module.exports = FormFieldOptionBuilder;
