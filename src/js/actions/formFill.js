import REST from '../utils/REST';
import history from '../routeHistory';

export const FORM_FILL_EDIT_LOAD = 'FORM_FILL_EDIT_LOAD';
export const FORM_FILL_EDIT_LOAD_SUCCESS = 'FORM_FILL_EDIT_LOAD_SUCCESS';
export const FORM_FILL_ADD = 'FORM_FILL_ADD';
export const FORM_FILL_ADD_SUCCESS = 'FORM_FILL_ADD_SUCCESS';
export const FORM_FILL_ADD_FAILURE = 'FORM_FILL_ADD_FAILURE';
export const FORM_FILL_UPDATE = 'FORM_FILL_UPDATE';
export const FORM_FILL_UPDATE_SUCCESS = 'FORM_FILL_UPDATE_SUCCESS';
export const FORM_FILL_UPDATE_FAILURE = 'FORM_FILL_UPDATE_FAILURE';
export const FORM_FILL_DELETE = 'FORM_FILL_DELETE';
export const FORM_FILL_DELETE_SUCCESS = 'FORM_FILL_DELETE_SUCCESS';
export const FORM_FILL_UNLOAD = 'FORM_FILL_UNLOAD';

export function loadFormFillEdit (formId, fillId) {
  return function (dispatch) {
    dispatch({ type: FORM_FILL_EDIT_LOAD, formId: formId, fillId: fillId });
    const path = (fillId ? `/forms/${formId}/fills/${fillId}/edit` :
      `/forms/${formId}/fills/new`);
    REST.get(path).then(response => {
      dispatch({
        type: FORM_FILL_EDIT_LOAD_SUCCESS,
        form: response.body.form,
        formFill: response.body.formFill,
        edit: response.body.edit
      });
    });
  };
}

export function addFormFill (formId, token, filledFields, routeAfter) {
  return function (dispatch) {
    dispatch({ type: FORM_FILL_ADD, formId: formId });
    let data = {
      filledFields: filledFields,
      email_address_confirmation: ''
    };
    REST.post(`/forms/${formId}/fills`, token, data)
      .then(response => {
        dispatch({ type: FORM_FILL_ADD_SUCCESS, formFill: response.body });
        if (routeAfter) {
          history.push(`/forms/${formId}/fills`);
        }
      })
      .catch(err => {
        let errors;
        if (err.response && err.response.text) {
          errors = JSON.parse(err.response.text).errors;
        }
        dispatch({ type: FORM_FILL_ADD_FAILURE, error: err, errors: errors });
      });
  };
}

export function updateFormFill (formId, id, token, filledFields, routeAfter) {
  return function (dispatch) {
    dispatch({ type: FORM_FILL_UPDATE, formId: formId, id: id });
    let data = {
      filledFields: filledFields,
      email_address_confirmation: ''
    };
    REST.put(`/forms/${formId}/fills/${id}`, token, data)
      .then(response => {
        dispatch({ type: FORM_FILL_UPDATE_SUCCESS, formFill: response.body });
        if (routeAfter) {
          history.push(`/forms/${formId}/fills`);
        }
      }).catch(err => {
        let errors;
        if (err.response && err.response.text) {
          errors = JSON.parse(err.response.text).errors;
        }
        dispatch({ type: FORM_FILL_UPDATE_FAILURE, error: err, errors: errors });
      });
  };
}

export function deleteFormFill (formId, id, token, routeAfter) {
  return function (dispatch) {
    dispatch({ type: FORM_FILL_DELETE, formId: formId, id: id });
    REST.del(`/forms/${formId}/fills/${id}`, token).then(response => {
      dispatch({ type: FORM_FILL_DELETE_SUCCESS });
      if (routeAfter) {
        history.push(`/forms/${formId}/fills`);
      }
    });
  };
}

export function unloadFormFill () {
  return { type: FORM_FILL_UNLOAD };
}
