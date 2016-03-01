import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { loadFormEdit, updateForm, unloadForm } from '../../actions/actions';
import CloseIcon from '../icons/CloseIcon';
import DragAndDrop from '../../utils/DragAndDrop';
import FormSectionBuilder from './FormSectionBuilder';
import formBuilderUtils from './formBuilderUtils';

const CLASS_ROOT = "form-builder";
const PLACEHOLDER_CLASS = `${CLASS_ROOT}__placeholder`;

export default class FormBuilder extends Component {

  constructor (props) {
    super(props);
    this._onSubmit = this._onSubmit.bind(this);
    this._dragStart = this._dragStart.bind(this);
    this._dragOver = this._dragOver.bind(this);
    this._dragEnd = this._dragEnd.bind(this);
    this.state = { form: props.form };
  }

  componentDidMount () {
    this.props.dispatch(loadFormEdit(this.props.id));
  }

  componentWillReceiveProps (nextProps) {
    if (nextProps.id !== this.props.id) {
      this.props.dispatch(loadFormEdit(nextProps.id));
    }
    this.setState({ form: nextProps.form });
  }

  componentWillUnmount () {
    this.props.dispatch(unloadForm());
  }

  _onSubmit (event) {
    event.preventDefault();
    const { edit: { updateUrl, authenticityToken, pageId }} = this.props;
    const { form } = this.state;
    this.props.dispatch(updateForm(updateUrl, authenticityToken, form, pageId));
  }

  _dragStart (event) {
    this._dragAndDrop = DragAndDrop.start({
      event: event,
      itemClass: `${CLASS_ROOT}__section`,
      placeholderClass: PLACEHOLDER_CLASS,
      list: this.state.form.formSections.slice(0)
    });
  }

  _dragOver (event) {
    this._dragAndDrop.over(event);
  }

  _dragEnd (event) {
    let form = this.state.form;
    let sections = this._dragAndDrop.end(event);
    sections.forEach(function (section, index) {
      section.formIndex = index + 1;
    });
    form.formSections = sections;
    this.setState({form: form});
  }

  _onAddSection () {
    let form = this.state.form;
    const section = {
      "_id": `__${(new Date()).getTime()}`,
      name: "New section",
      formFields: []
    };
    form.formSections.push(section);
    this.setState({form: form});
  }

  _onSectionUpdate (section) {
    let form = this.state.form;
    form.formSections = form.formSections.map(formSection => {
      return (formBuilderUtils.idsMatch(section, formSection) ? section : formSection);
    });
    this.setState({form: form});
  }

  _onSectionRemove (id) {
    let form = this.state.form;
    form.formSections = form.formSections.filter(formSection => {
      return (id !== formBuilderUtils.itemId(formSection));
    });
    this.setState({form: form});
  }

  render () {
    const { edit: { message, cancelUrl, editContextUrl }} = this.props;
    const { form } = this.state;
    const sections = form.formSections.map((formSection, index) => {
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
    });

    let errorMessage;
    if (message) {
      errorMessage = (
        <div className="form__header-message">
          {message}
        </div>
      );
    }

    return (
      <form className="form">
        <div className="form__header">
          <span className="form__title">Edit {form.name}</span>
          {errorMessage}
          <a className="control-icon" href={cancelUrl}>
            <CloseIcon />
          </a>
        </div>

        <div className="form__contents">
          <div className={CLASS_ROOT}>
            <div className={`${CLASS_ROOT}__sections`}
              onDragOver={this._dragOver}>
              {sections}
            </div>
          </div>
        </div>

        <div className="form__footer">
          <input type="submit" value="Update" className="btn btn--primary"
            onClick={this._onSubmit} />
          <a href={editContextUrl}>
            Context
          </a>
        </div>
      </form>
    );
  }
}

FormBuilder.propTypes = {
  id: PropTypes.string,
  form: PropTypes.shape({
    name: PropTypes.string,
    formSections: PropTypes.array
  }),
  edit: PropTypes.shape({
    authenticityToken: PropTypes.string,
    cancelUrl: PropTypes.string,
    editContextUrl: PropTypes.string,
    updateUrl: PropTypes.string
  })
};

let select = (state, props) => ({
  id: props.params.id,
  form: state.form,
  edit: state.formEdit
});

export default connect(select)(FormBuilder);
