import REST from '../utils/REST';
import history from '../routeHistory';

export const FORM_LOAD = 'FORM_LOAD';
export const FORM_LOAD_SUCCESS = 'FORM_LOAD_SUCCESS';
export const FORM_EDIT_LOAD = 'FORM_EDIT_LOAD';
export const FORM_EDIT_LOAD_SUCCESS = 'FORM_EDIT_LOAD_SUCCESS';
export const FORM_UPDATE = 'FORM_UPDATE';
export const FORM_UPDATE_SUCCESS = 'FORM_UPDATE_SUCCESS';
export const FORM_FILLS_LOAD = 'FORM_FILLS_LOAD';
export const FORM_FILLS_LOAD_SUCCESS = 'FORM_FILLS_LOAD_SUCCESS';
export const FORM_FILL_EDIT_LOAD = 'FORM_FILL_EDIT_LOAD';
export const FORM_FILL_EDIT_LOAD_SUCCESS = 'FORM_FILL_EDIT_LOAD_SUCCESS';
export const FORM_FILL_ADD = 'FORM_FILL_ADD';
export const FORM_FILL_ADD_SUCCESS = 'FORM_FILL_ADD_SUCCESS';
export const FORM_FILL_UPDATE = 'FORM_FILL_UPDATE';
export const FORM_FILL_UPDATE_SUCCESS = 'FORM_FILL_UPDATE_SUCCESS';
export const FORM_FILL_DELETE = 'FORM_FILL_DELETE';
export const FORM_FILL_DELETE_SUCCESS = 'FORM_FILL_DELETE_SUCCESS';
export const FORM_UNLOAD = 'FORM_UNLOAD';

export function loadForm (id) {
  return function (dispatch) {
    const loc = history.createLocation(document.location.pathname +
      document.location.search);
    dispatch({ type: FORM_LOAD, id: id });
    REST.get(loc.pathname).end((err, res) => {
      if (!err && res.ok) {
        dispatch({
          type: FORM_LOAD_SUCCESS,
          form: res.body.form
        });
      }
    });
  };
}

export function loadFormEdit (id) {
  return function (dispatch) {
    const loc = history.createLocation(document.location.pathname +
      document.location.search);
    dispatch({ type: FORM_EDIT_LOAD, id: id });
    REST.get(loc.pathname).end((err, res) => {
      if (!err && res.ok) {
        dispatch({
          type: FORM_EDIT_LOAD_SUCCESS,
          form: res.body.form,
          edit: res.body.edit
        });
      }
    });
  };
}

export function updateForm (path, token, form, pageId) {
  return function (dispatch) {
    dispatch({ type: FORM_UPDATE, path: path });
    let data = { form: form };
    if (pageId) {
      data.pageId = pageId;
    }
    REST.post(path, token, data).end((err, res) => {
      if (!err && res.ok) {
        dispatch({ type: FORM_UPDATE_SUCCESS });
        location = res.body.redirect_to;
      }
    });
  };
}

// deleteForm()?

export function loadFormFills (formId) {
  return function (dispatch) {
    const loc = history.createLocation(document.location.pathname +
      document.location.search);
    dispatch({ type: FORM_FILLS_LOAD, id: id });
    REST.get(loc.pathname).end((err, res) => {
      if (!err && res.ok) {
        dispatch({
          type: FORM_FILLS_LOAD_SUCCESS,
          form: res.body.form
        });
      }
    });
  };
}

export function loadFormFillEdit (formId, fillId) {
  return function (dispatch) {
    const loc = history.createLocation(document.location.pathname +
      document.location.search);
    dispatch({ type: FORM_FILL_EDIT_LOAD, formId: formId, fillId: fillId });
    REST.get(loc.pathname).end((err, res) => {
      if (!err && res.ok) {
        console.log('!!! loadFormFillEdit', res.body);
        dispatch({
          type: FORM_FILL_EDIT_LOAD_SUCCESS,
          form: res.body.form,
          formFill: res.body.filledForm,
          edit: res.body.edit
        });
      }
    });
  };
}

export function addFormFill (path, token, filledFields, pageId) {
  return function (dispatch) {
    dispatch({ type: FORM_FILL_ADD, path: path });
    let data = {
      filledFields: filledFields,
      email_address_confirmation: ''
    };
    if (pageId) {
      data.pageId = pageId;
    }
    REST.post(path, token, data).end((err, res) => {
      if (!err && res.ok) {
        dispatch({ type: FORM_FILL_ADD_SUCCESS, filledForm: res.body });
        if (res.body.redirectUrl) {
          // not in a page
          window.location = res.body.redirectUrl;
        // } else {
        //   // in a page
        //   let filledForm = response;
        //   let filledForms;
        //   if ('new' === this.state.mode) {
        //     filledForms = this.state.filledForms;
        //     filledForms.push(filledForm);
        //   } else {
        //     filledForms = this.state.filledForms.map(function (filledForm2) {
        //       return (filledForm2.id === filledForm.id ? filledForm : filledForm2);
        //     });
        //   }
        //   this.setState({
        //     mode: 'show',
        //     filledForm: null,
        //     filledForms: filledForms,
        //     fieldErrors: {}
        //   });
        // }
        // location = res.body.redirect_to;
        }
      }
    });
  };
}

export function updateFormFill (path, token, filledFields, pageId) {
  return function (dispatch) {
    dispatch({ type: FORM_FILL_UPDATE, path: path });
    let data = {
      filledFields: filledFields,
      email_address_confirmation: ''
    };
    if (pageId) {
      data.pageId = pageId;
    }
    REST.put(path, token, data).end((err, res) => {
      if (!err && res.ok) {
        dispatch({ type: FORM_FILL_UPDATE_SUCCESS, filledForm: res.body });
        if (res.body.redirectUrl) {
          // not in a page
          window.location = res.body.redirectUrl;
        // } else {
        //   // in a page
        //   let filledForm = response;
        //   let filledForms;
        //   if ('new' === this.state.mode) {
        //     filledForms = this.state.filledForms;
        //     filledForms.push(filledForm);
        //   } else {
        //     filledForms = this.state.filledForms.map(function (filledForm2) {
        //       return (filledForm2.id === filledForm.id ? filledForm : filledForm2);
        //     });
        //   }
        //   this.setState({
        //     mode: 'show',
        //     filledForm: null,
        //     filledForms: filledForms,
        //     fieldErrors: {}
        //   });
        // }
        // location = res.body.redirect_to;
        }
      }
    });
  };
}

export function deleteFormFill (path, token, pageId) {
  return function (dispatch) {
    dispatch({ type: FORM_FILL_DELETE, path: path });
    REST.delete(path, token).end((err, res) => {
      if (!err && res.ok) {
        dispatch({ type: FORM_FILL_DELETE_SUCCESS });
        location = res.body.redirect_to;
      }
    });
  };
}

export function unloadForm () {
  return { type: FORM_UNLOAD };
}
