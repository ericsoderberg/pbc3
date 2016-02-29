import REST from '../utils/REST';
import history from '../routeHistory';

export const MESSAGES_LOAD = 'MESSAGES_LOAD';
export const MESSAGES_LOAD_SUCCESS = 'MESSAGES_LOAD_SUCCESS';
export const MESSAGES_SEARCH = 'MESSAGES_SEARCH';
export const MESSAGES_SEARCH_SUCCESS = 'MESSAGES_SEARCH_SUCCESS';
export const MESSAGES_MORE = 'MESSAGES_MORE';
export const MESSAGES_MORE_SUCCESS = 'MESSAGES_MORE_SUCCESS';
export const MESSAGES_UNLOAD = 'MESSAGES_UNLOAD';

function handler (dispatch, type) {
  return (err, res) => {
    if (!err && res.ok) {
      dispatch({
        type: MESSAGES_LOAD_SUCCESS,
        messages: res.body.messages,
        filter: res.body.filter,
        count: res.body.count
      });
    }
  };
}

export function loadMessages () {
  return function (dispatch) {
    // bring in any query from the location
    const loc = history.createLocation(document.location.pathname +
      document.location.search);
    const search = loc.query.search;
    dispatch({ type: MESSAGES_LOAD, search: search });
    let path = loc.pathname;
    if (search) {
      path += `?search=${encodeURIComponent(search)}`;
    }
    REST.get(path).end(handler(dispatch, MESSAGES_LOAD_SUCCESS));
  };
}

export function searchMessages (search) {
  return function (dispatch) {
    dispatch({ type: MESSAGES_SEARCH, search: search });
    let path = document.location.pathname;
    if (search) {
      path += `?search=${encodeURIComponent(search)}`;
    }
    REST.get(path).end(handler(dispatch, MESSAGES_SEARCH_SUCCESS));
    history.replace(path);
  };
}

export function moreMessages (offset, search) {
  return function (dispatch) {
    dispatch({ type: MESSAGES_MORE, offset: offset, search: search });
    let path = document.location.pathname;
    path += `$?offset=${encodeURIComponent(offset)}`;
    if (search) {
      path += `&search=${encodeURIComponent(search)}`;
    }
    REST.get(path).end((err, res) => {
      if (!err && res.ok) {
        dispatch({
          type: MESSAGES_MORE_SUCCESS,
          messages: res.body.messages,
          filter: res.body.search,
          count: res.body.count
        });
      }
    });
  };
}

export function unloadMessages () {
  return { type: MESSAGES_UNLOAD };
}
