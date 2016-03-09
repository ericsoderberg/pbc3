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
    // bring in any pageId from the location
    const loc = history.createLocation(document.location.pathname +
      document.location.search);
    const pageId = loc.query.page_id;
    dispatch({ type: FORM_EDIT_LOAD, id: id, pageId: pageId });
    let path = `/forms/${id}/edit_contents`;
    if (pageId) {
      path += `?page_id=${pageId}`;
    }
    REST.get(path).then(response => {
      dispatch({
        type: FORM_EDIT_LOAD_SUCCESS,
        form: response.body,
        edit: response.body.edit
      });
    });
  };
}

export function updateForm (form, edit) {
  return function (dispatch) {
    dispatch({ type: FORM_UPDATE, path: edit.updateUrl });
    let data = { form: form };
    if (edit.pageId) {
      data.pageId = edit.pageId;
    }
    REST.post(edit.updateUrl, edit.authenticityToken, data).then(response => {
      dispatch({ type: FORM_UPDATE_SUCCESS });
      location = response.body.redirect_to;
    });
  };
}

export function unloadForm () {
  return { type: FORM_UNLOAD };
}
