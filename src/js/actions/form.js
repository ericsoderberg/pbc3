import REST from '../utils/REST';

export const FORM_LOAD = 'FORM_LOAD';
export const FORM_LOAD_SUCCESS = 'FORM_LOAD_SUCCESS';
export const FORM_EDIT_LOAD = 'FORM_EDIT_LOAD';
export const FORM_EDIT_LOAD_SUCCESS = 'FORM_EDIT_LOAD_SUCCESS';
export const FORM_UPDATE = 'FORM_UPDATE';
export const FORM_UPDATE_SUCCESS = 'FORM_UPDATE_SUCCESS';
export const FORM_UNLOAD = 'FORM_UNLOAD';

export function loadForm (id) {
  return function (dispatch) {
    dispatch({ type: FORM_LOAD, id: id });
    REST.get(`/forms/${id}`).then(response => {
      dispatch({
        type: FORM_LOAD_SUCCESS,
        form: response.body
      });
    });
  };
}

export function loadFormEdit (id) {
  return function (dispatch) {
    dispatch({ type: FORM_EDIT_LOAD, id: id });
    REST.get(`/forms/${id}/edit_contents`).then(response => {
      dispatch({
        type: FORM_EDIT_LOAD_SUCCESS,
        form: response.body,
        edit: response.body.edit
      });
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
    REST.post(path, token, data).then(response => {
      dispatch({ type: FORM_UPDATE_SUCCESS });
      location = response.body.redirect_to;
    });
  };
}

// deleteForm()?

export function unloadForm () {
  return { type: FORM_UNLOAD };
}
