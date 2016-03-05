import REST from '../utils/REST';
import history from '../routeHistory';

export const PAGE_LOAD = 'PAGE_LOAD';
export const PAGE_LOAD_SUCCESS = 'PAGE_LOAD_SUCCESS';
export const PAGE_EDIT_LOAD = 'PAGE_EDIT_LOAD';
export const PAGE_EDIT_LOAD_SUCCESS = 'PAGE_EDIT_LOAD_SUCCESS';
export const PAGE_UPDATE_CONTENTS_ORDER = 'PAGE_UPDATE_CONTENTS_ORDER';
export const PAGE_UPDATE_CONTENTS_ORDER_SUCCESS =
  'PAGE_UPDATE_CONTENTS_ORDER_SUCCESS';
export const PAGE_UNLOAD = 'PAGE_UNLOAD';

export function loadPage (id) {
  return function (dispatch) {
    const loc = history.createLocation(document.location.pathname +
      document.location.search);
    dispatch({ type: PAGE_LOAD, id: id });
    REST.get(loc.pathname).then(response => {
      dispatch({ type: PAGE_LOAD_SUCCESS, page: response.body });
    });
  };
}

export function loadPageEdit (id) {
  return function (dispatch) {
    const loc = history.createLocation(document.location.pathname +
      document.location.search);
    dispatch({ type: PAGE_EDIT_LOAD, id: id });
    REST.get(loc.pathname).then(response => {
      dispatch({
        type: PAGE_EDIT_LOAD_SUCCESS,
        page: response.body.page,
        edit: response.body.edit
      });
    });
  };
}

export function updatePageContentsOrder (path, token, elementIds) {
  return function (dispatch) {
    dispatch({ type: PAGE_UPDATE_CONTENTS_ORDER, path: path });
    const data = { element_order: elementIds };
    REST.patch(path, token, data).then(response => {
      dispatch({ type: PAGE_UPDATE_CONTENTS_ORDER_SUCCESS });
      location = response.body.redirect_to;
    });
  };
}

export function unloadPage () {
  return { type: PAGE_UNLOAD };
}