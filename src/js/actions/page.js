import REST from '../utils/REST';
import history from '../routeHistory';

export const PAGE_LOAD = 'PAGE_LOAD';
export const PAGE_LOAD_SUCCESS = 'PAGE_LOAD_SUCCESS';
export const PAGE_UNLOAD = 'PAGE_UNLOAD';

export function loadPage (id) {
  return function (dispatch) {
    const loc = history.createLocation(document.location.pathname +
      document.location.search);
    dispatch({ type: PAGE_LOAD, id: id });
    REST.get(loc.pathname).end((err, res) => {
      if (!err && res.ok) {
        dispatch({
          type: PAGE_LOAD_SUCCESS,
          page: res.body
        });
      }
    });
  };
}

export function unloadPage () {
  return { type: PAGE_UNLOAD };
}
