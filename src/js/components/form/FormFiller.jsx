import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { loadFormFillEdit, addFormFill, updateFormFill,
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
    this._onDelete = this._onDelete.bind(this);
    this._onChange = this._onChange.bind(this);

    // let mode;
    // let filledForm;
    //
    // if (props.form.mode) {
    //   mode = props.form.mode;
    // } else if (props.form.filledForms.length === 0 || 'form' !== props.tag) {
    //   mode = 'new';
    // } else {
    //   mode = 'show';
    // }
    // if ('new' === mode) {
    //   filledForm = {filledFields: []};
    // } else if ('edit' === mode) {
    //   filledForm = props.form.filledForms[0];
    // }

    this.state = {
      formFill: props.formFill,
      fieldErrors: {}
    };
  }

  componentDidMount () {
    this.props.dispatch(loadFormFillEdit(this.props.formId, this.props.id));
  }

  componentWillReceiveProps (nextProps) {
    if (nextProps.id !== this.props.id) {
      this.props.dispatch(loadFormFillEdit(nextProps.formId, nextProps.id));
    }
    this.setState({ formFill: nextProps.formFill });
  }

  componentWillUnmount () {
    this.props.dispatch(unloadFormFill());
  }

  _onSubmit (event) {
    event.preventDefault();
    const { id, formId, form, edit: { authenticityToken, pageId }} = this.props;
    const { formFill } = this.state;
    const filledFields = filledFieldsForForm(form, formFill);
    if (id) {
      this.props.dispatch(updateFormFill(formId, id, authenticityToken, filledFields, pageId));
    } else {
      this.props.dispatch(addFormFill(formId, authenticityToken, filledFields, pageId));
    }
    // const filledForm = this.state.filledForm;
    // const filledFields = filledFieldsForForm(this.props.form, filledForm);
    // let url;
    // let action;
    // if ('new' === this.state.mode) {
    //   url = this.props.form.createUrl;
    //   action = 'post';
    // } else {
    //   url = this.state.filledForm.url;
    //   action = 'put';
    // }
    // var data = {
    //   filledFields: filledFields,
    //   email_address_confirmation: ''
    // };
    // if (this.props.form.pageId) {
    //   data.pageId = this.props.form.pageId;
    // }
    // const token = this.props.form.authenticityToken;
    // REST[action](url, token, data,
    //   function (response) {
    //     // Successful submit
    //     if (response.redirectUrl) {
    //       // not in a page
    //       window.location = response.redirectUrl;
    //     } else {
    //       // in a page
    //       let filledForm = response;
    //       let filledForms;
    //       if ('new' === this.state.mode) {
    //         filledForms = this.state.filledForms;
    //         filledForms.push(filledForm);
    //       } else {
    //         filledForms = this.state.filledForms.map(function (filledForm2) {
    //           return (filledForm2.id === filledForm.id ? filledForm : filledForm2);
    //         });
    //       }
    //       this.setState({
    //         mode: 'show',
    //         filledForm: null,
    //         filledForms: filledForms,
    //         fieldErrors: {}
    //       });
    //     }
    //   }.bind(this), function (errors) {
    //     this.setState({fieldErrors: errors});
    //   }.bind(this));
  }

  _onDelete () {
    const { formFill, edit: { authenticityToken, pageId } } = this.props;
    this.props.dispatch(deleteFormFill(formFill.url, authenticityToken, pageId));
    // const token = this.props.form.authenticityToken;
    // REST.delete(filledForm.url, token, function (response) {
    //   if (response.result === 'ok') {
    //     const filledForms = this.state.filledForms.filter(function (filled) {
    //       return (filled.id !== filledForm.id);
    //     });
    //     let mode = this.state.mode;
    //     filledForm = null;
    //     if (filledForms.length === 0) {
    //       mode = 'new';
    //       filledForm = {filledFields: []};
    //     } else {
    //       mode = 'show';
    //     }
    //     this.setState({filledForms: filledForms,
    //       mode: mode, filledForm: filledForm});
    //   }
    // }.bind(this));
  }

  _onChange (formFill) {
    this.setState({formFill: formFill});
  }

  // _onCancel (event) {
  //   this.setState({mode: 'show', filledForm: null});
  // }

  // _onAdd (event) {
  //   event.preventDefault();
  //   this.setState({mode: 'new', filledForm: {filledFields: []}});
  // }

  render () {
    const { id, form, edit: { cancelPath } } = this.props;
    const { formFill, fieldErrors } = this.state;

    const sections = form.formSections.map(formSection => {
      return (
        <FormSection key={formSection.id}
          formSection={formSection}
          formFill={formFill}
          fieldErrors={fieldErrors}
          onChange={this._onChange} />
      );
    });

    let remove;
    if (id) {
      remove = (
        <a onClick={(event) => {
          event.preventDefault();
          if (window.confirm('Are you sure?')) {
            this._onDelete();
          }
        }}>Remove</a>
      );
    }

    let headerCancel;
    if (cancelPath) {
      headerCancel = (
        <Link className="control-icon" to={cancelPath}>
          <CloseIcon />
        </Link>
      );
    }

    // let cancel;
      // } else {
      //   headerCancel = (
      //     <a className="control-icon" onClick={this._onCancel}>
      //       <CloseIcon />
      //     </a>
      //   );
      //   cancel = <a onClick={this._onCancel}>Cancel</a>;
      // }
    // } else if ('new' === this.props.form.mode) {
    //   headerCancel = (
    //     <a className="control-icon" href={this.props.form.indexUrl}>
    //       <CloseIcon />
    //     </a>
    //   );
    // } else if (form.manyPerUser && this.state.filledForms.length > 0) {
    //   headerCancel = (
    //     <a className="control-icon" onClick={this._onCancel}>
    //       <CloseIcon />
    //     </a>
    //   );
    //   cancel = <a onClick={this._onCancel}>Cancel</a>;
    // }

    return (
      <form className={CLASS_ROOT}>
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
          {/*}{cancel}{*/}
        </div>
      </form>
    );
  }
};

FormFiller.propTypes = {
  id: PropTypes.string,
  formId: PropTypes.string.isRequired,
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
    updateUrl: PropTypes.string
  })
};

let select = (state, props) => ({
  form: state.form,
  formFill: state.formFill,
  formId: props.params.formId,
  id: props.params.id,
  edit: state.formFillEdit
});

export default connect(select)(FormFiller);
