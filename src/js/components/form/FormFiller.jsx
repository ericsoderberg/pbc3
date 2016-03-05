import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { loadFormFillEdit, addFormFill, updateFormFill, deleteFormFill,
  unloadFormFill } from '../../actions/actions';
import { Link } from 'react-router';
import CloseIcon from '../icons/CloseIcon';
import FormSection from './FormSection';
import formUtils from './formUtils';

const CLASS_ROOT = "form";

function filledFieldsForForm (form, formFill) {
  let result = {};
  formFill.filledFields.forEach(filledField => {
    var formField = formUtils.findFormField(form, filledField.formFieldId);
    if ('single choice' === formField.fieldType) {
      if (filledField.filledFieldOptions.length > 0) {
        result[formField.id] =
          filledField.filledFieldOptions[0].formFieldOptionId;
      }
    } else if ('multiple choice' === formField.fieldType) {
      if (filledField.filledFieldOptions.length > 0) {
        result[formField.id] =
          filledField.filledFieldOptions.map(filledFieldOption => {
            return (filledFieldOption.formFieldOptionId);
          });
      }
    } else {
      result[formField.id] = filledField.value;
    }
  });
  return result;
}

export default class FormFiller extends Component {

  constructor (props) {
    super(props);
    this._onSubmit = this._onSubmit.bind(this);
    this._onRemove = this._onRemove.bind(this);
    this._onCancelRemove = this._onCancelRemove.bind(this);
    this._onDelete = this._onDelete.bind(this);
    this._onChange = this._onChange.bind(this);
    this.state = {
      formFill: props.formFill,
      fieldErrors: {}
    };
  }

  componentDidMount () {
    this.props.dispatch(loadFormFillEdit(this.props.formId, this.props.id));
  }

  componentWillReceiveProps (nextProps) {
    if (this.props.onClose && nextProps.edit.done) {
      this.props.onClose(true);
    } else if (this.props.id && nextProps.id !== this.props.id) {
      this.props.dispatch(loadFormFillEdit(nextProps.formId, nextProps.id));
    }
    this.setState({ formFill: nextProps.formFill });
  }

  componentWillUnmount () {
    this.props.dispatch(unloadFormFill());
  }

  _onSubmit (event) {
    event.preventDefault();
    const { id, formId, form, edit: { authenticityToken }, onClose } = this.props;
    const { formFill } = this.state;
    const filledFields = filledFieldsForForm(form, formFill);
    if (id) {
      this.props.dispatch(updateFormFill(formId, id, authenticityToken,
        filledFields, (! onClose)));
    } else {
      this.props.dispatch(addFormFill(formId, authenticityToken,
        filledFields, (! onClose)));
    }
  }

  _onRemove (event) {
    event.preventDefault();
    this.setState({ removing: true });
  }

  _onCancelRemove () {
    this.setState({ removing: false });
  }

  _onDelete () {
    const { id, formId, edit: { authenticityToken }, onClose } = this.props;
    this.props.dispatch(deleteFormFill(formId, id, authenticityToken,
      (! onClose)));
  }

  _onChange (formFill) {
    this.setState({formFill: formFill});
  }

  render () {
    const { id, form, edit: { cancelPath, errors }, onClose,
      disabled } = this.props;
    const { formFill, removing } = this.state;

    const sections = form.formSections.map(formSection => {
      return (
        <FormSection key={formSection.id}
          formSection={formSection}
          formFill={formFill}
          errors={errors}
          onChange={this._onChange} />
      );
    });

    let remove;
    if (id) {
      if (removing) {
        remove = (
          <span className={`${CLASS_ROOT}__remove-confirm`}>
            <button type="button" className="btn"
              onClick={this._onDelete}>Confirm</button>
            <button type="button" className="btn"
              onClick={this._onCancelRemove}>Cancel</button>
          </span>
        );
      } else {
        remove = <a onClick={this._onRemove}>Remove</a>;
      }
    }

    let headerCancel;
    if (onClose) {
      headerCancel = (
        <a className="control-icon" onClick={(event) => {
          event.preventDefault();
          onClose();
        }}>
          <CloseIcon />
        </a>
      );
    } else if (cancelPath) {
      headerCancel = (
        <Link className="control-icon" to={cancelPath}>
          <CloseIcon />
        </Link>
      );
    }

    const Tag = (disabled ? 'div' : 'form');
    return (
      <Tag className={CLASS_ROOT}>
        <div className={`${CLASS_ROOT}__header`}>
          <span className="form__title">{form.name}</span>
          {headerCancel}
        </div>

        <div className={`${CLASS_ROOT}__contents`}>
          <input name="email_address_confirmation" value=""
            id="email_address_confirmation" placeholder="email address" />
          <div className={`${CLASS_ROOT}__sections`}>
            {sections}
          </div>
        </div>

        <div className={`${CLASS_ROOT}__footer`}>
          <input type="submit" value={form.submitLabel || 'Submit'}
            className="btn btn--primary"
            onClick={this._onSubmit} />
          {remove}
        </div>
      </Tag>
    );
  }
};

FormFiller.propTypes = {
  id: PropTypes.number,
  disabled: PropTypes.bool,
  formId: PropTypes.number.isRequired,
  form: PropTypes.shape({
    name: PropTypes.string,
    formSections: PropTypes.array
  }),
  formFill: PropTypes.shape({
    name: PropTypes.string,
    filledFields: PropTypes.array
  }),
  edit: PropTypes.shape({
    authenticityToken: PropTypes.string,
    cancelPath: PropTypes.string,
    done: PropTypes.bool,
    errors: PropTypes.object,
    updateUrl: PropTypes.string
  }),
  onClose: PropTypes.func
};

let select = (state, props) => ({
  form: state.form,
  formFill: state.formFill,
  formId: (props.params ?  parseInt(props.params.formId, 10) : props.formId),
  id: (props.params ? parseInt(props.params.id, 10) : props.id),
  edit: state.formFillEdit
});

export default connect(select)(FormFiller);
