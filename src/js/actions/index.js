import REST from '../utils/REST';
import history from '../routeHistory';

export const INDEX_LOAD = 'INDEX_LOAD';
export const INDEX_LOAD_SUCCESS = 'INDEX_LOAD_SUCCESS';
export const INDEX_SEARCH = 'INDEX_SEARCH';
export const INDEX_SEARCH_SUCCESS = 'INDEX_SEARCH_SUCCESS';
export const INDEX_MORE = 'INDEX_MORE';
export const INDEX_MORE_SUCCESS = 'INDEX_MORE_SUCCESS';
export const INDEX_UNLOAD = 'INDEX_UNLOAD';

export function loadIndex (category, context) {
  return function (dispatch) {
    // bring in any query from the location
    const loc = history.createLocation(document.location.pathname +
      document.location.search);
    const search = loc.query.search;
    dispatch({
      type: INDEX_LOAD,
      category: category,
      context: context,
      search: search
    });
    let path = loc.pathname;
    if (search) {
      path += `?search=${encodeURIComponent(search)}`;
    }
    REST.get(path).end((err, res) => {
      if (!err && res.ok) {
        dispatch({
          type: INDEX_LOAD_SUCCESS,
          category: category,
          context: (context ? res.body[context] : undefined),
          items: res.body[category],
          filter: res.body.filter,
          count: res.body.count
        });
      }
    });
  };
}

export function searchIndex (category, search) {
  return function (dispatch) {
    dispatch({ type: INDEX_SEARCH, category: category, search: search });
    let path = document.location.pathname;
    if (search) {
      path += `?search=${encodeURIComponent(search)}`;
    }
    REST.get(path).end((err, res) => {
      if (!err && res.ok) {
        dispatch({
          type: INDEX_SEARCH_SUCCESS,
          category: category,
          search: search,
          items: res.body[category],
          filter: res.body.filter,
          count: res.body.count
        });
      }
    });
    history.replace(path);
  };
}

export function moreIndex (category, offset, search) {
  return function (dispatch) {
    dispatch({ type: INDEX_MORE, category: category, offset: offset, search: search });
    let path = document.location.pathname;
    path += `$?offset=${encodeURIComponent(offset)}`;
    if (search) {
      path += `&search=${encodeURIComponent(search)}`;
    }
    REST.get(path).end((err, res) => {
      if (!err && res.ok) {
        dispatch({
          type: INDEX_MORE_SUCCESS,
          category: category,
          offset: offset,
          search: search,
          items: res.body[category]
        });
      }
    });
  };
}

export function unloadIndex () {
  return { type: INDEX_UNLOAD };
}
