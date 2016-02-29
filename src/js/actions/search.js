import REST from '../utils/REST';
import history from '../routeHistory';

export const SEARCH_LOAD = 'SEARCH_LOAD';
export const SEARCH_QUERY = 'SEARCH_QUERY';
export const SEARCH_QUERY_SUCCESS = 'SEARCH_QUERY_SUCCESS';
export const SEARCH_UNLOAD = 'SEARCH_UNLOAD';

export function loadSearch () {
  return function (dispatch) {
    dispatch({ type: SEARCH_LOAD });
    // bring in any query from the location
    const loc = history.createLocation(document.location.pathname +
      document.location.search);
    const query = loc.query.q;
    if (query) {
      dispatch(searchQuery(query));
    }
  };
}

export function searchQuery (query) {
  return function (dispatch) {
    dispatch({ type: SEARCH_QUERY, query: query });
    const search = `?q=${encodeURIComponent(query)}`;
    REST.get(search).end((err, res) => {
      if (!err && res.ok) {
        dispatch({
          type: SEARCH_QUERY_SUCCESS,
          query: query,
          results: res.body.results
        });
      }
    });
    history.replace({
      pathname: document.location.pathname,
      search: search
    });
  };
}

export function unloadSearch () {
  return { type: SEARCH_UNLOAD };
}
