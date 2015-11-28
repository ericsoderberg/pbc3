var EditIcon = require('../icons/EditIcon');
var Layer = require('../../utils/Layer');
var FormFieldOptionEditor = require('./FormFieldOptionEditor');
var formBuilderUtils = require('./formBuilderUtils');

var CLASS_ROOT = "form-builder";

var FormFieldOptionBuilder = React.createClass({

  propTypes: {
    dragEnd: React.PropTypes.func.isRequired,
    dragStart: React.PropTypes.func.isRequired,
    edit: React.PropTypes.bool,
    fieldType: React.PropTypes.string.isRequired,
    index: React.PropTypes.number.isRequired,
    monetary: React.PropTypes.bool,
    onUpdate: React.PropTypes.func.isRequired,
    onRemove: React.PropTypes.func.isRequired,
    option: React.PropTypes.object.isRequired
  },

  _renderEdit: function () {
    return (
      <FormFieldOptionEditor option={this.props.option}
        onCancel={this._onCancelEdit}
        onUpdate={this._onUpdate}
        onRemove={this._onRemove}
        monetary={this.props.monetary} />
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
    this.props.onRemove(formBuilderUtils.itemId(this.props.option));
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
      <div className={CLASS_ROOT + "__field form__field"}
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
});

module.exports = FormFieldOptionBuilder;
