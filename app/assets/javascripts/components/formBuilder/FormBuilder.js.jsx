var CloseIcon = require('../icons/CloseIcon');
var DragAndDrop = require('../../utils/DragAndDrop');
var REST = require('../REST');
var FormSectionBuilder = require('./FormSectionBuilder');
var formBuilderUtils = require('./formBuilderUtils');

var CLASS_ROOT = "form-builder";
var PLACEHOLDER_CLASS = CLASS_ROOT + "__placeholder";

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
    // console.log('!!! FormBuilder _onSubmit', token, this.state.form);
    REST.post(url, token, data, function (response) {
      // console.log('!!! FormBuilder _onSubmit completed', response);
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
      return (formBuilderUtils.idsMatch(section, formSection) ? section : formSection);
    });
    this.setState({form: form});
  },

  _onSectionRemove: function (id) {
    var form = this.state.form;
    form.formSections = form.formSections.filter(function (formSection) {
      return (id !== formBuilderUtils.itemId(formSection));
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
        <FormSectionBuilder key={formBuilderUtils.itemId(formSection)}
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

    var message;
    if (this.props.editContents.message) {
      message = (
        <div className="form__header-message">
          {this.props.editContents.message}
        </div>
      );
    }

    return (
      <form className="form">
        <div className="form__header">
          <span className="form__title">Edit {form.name}</span>
          {message}
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
