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
    REST.get(path).then(response => {
      dispatch({
        type: INDEX_LOAD_SUCCESS,
        category: category,
        context: (context ? response.body[context] : undefined),
        result: {
          items: response.body[category],
          ...response.body
        }
      });
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
    REST.get(path).then((res) => {
      dispatch({
        type: INDEX_SEARCH_SUCCESS,
        category: category,
        search: search,
        result: {
          items: res.body[category],
          ...res.body
        }
      });
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
    REST.get(path).then((res) => {
      dispatch({
        type: INDEX_MORE_SUCCESS,
        category: category,
        offset: offset,
        search: search,
        result: {
          items: res.body[category],
          ...res.body
        }
      });
    });
  };
}

export function unloadIndex () {
  return { type: INDEX_UNLOAD };
}
