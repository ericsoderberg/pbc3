import REST from '../utils/REST';
import history from '../routeHistory';

export const FORM_LOAD = 'FORM_LOAD';
export const FORM_LOAD_SUCCESS = 'FORM_LOAD_SUCCESS';
export const FORM_EDIT_LOAD = 'FORM_EDIT_LOAD';
export const FORM_EDIT_LOAD_SUCCESS = 'FORM_EDIT_LOAD_SUCCESS';
export const FORM_UPDATE = 'FORM_UPDATE';
export const FORM_UPDATE_SUCCESS = 'FORM_UPDATE_SUCCESS';
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

export function unloadForm () {
  return { type: FORM_UNLOAD };
}
