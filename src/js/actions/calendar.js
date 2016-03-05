import REST from '../utils/REST';
import history from '../routeHistory';

export const CALENDAR_LOAD = 'CALENDAR_LOAD';
export const CALENDAR_LOAD_SUCCESS = 'CALENDAR_LOAD_SUCCESS';
export const CALENDAR_SEARCH = 'CALENDAR_SEARCH';
export const CALENDAR_SEARCH_SUCCESS = 'CALENDAR_SEARCH_SUCCESS';
export const CALENDAR_UNLOAD = 'CALENDAR_UNLOAD';

const handler = (dispatch, type) => {
  return (err, res) => {
    if (!err && res.ok) {
      dispatch({
        type: CALENDAR_LOAD_SUCCESS,
        daysOfWeek: res.body.daysOfWeek,
        weeks: res.body.weeks,
        filter: res.body.filter,
        newUrl: res.body.newUrl,
        next: res.body.next,
        previous: res.body.previous
      });
    }
  };
};

export function loadCalendar () {
  return function (dispatch) {
    // bring in any query from the location
    const loc = history.createLocation(document.location.pathname +
      document.location.search);
    const search = loc.query.search;
    dispatch({ type: CALENDAR_LOAD, search: search });
    let path = loc.pathname;
    if (search) {
      path += `?search=${encodeURIComponent(search)}`;
    }
    REST.get(path).end(handler(dispatch, CALENDAR_LOAD_SUCCESS));
  };
}

export function searchCalendar (search) {
  return function (dispatch) {
    dispatch({ type: CALENDAR_SEARCH, search: search });
    let path = document.location.pathname;
    if (search) {
      path += `?search=${encodeURIComponent(search)}`;
    }
    REST.get(path).end(handler(dispatch, CALENDAR_SEARCH_SUCCESS));
    history.replace(path);
  };
}

export function unloadCalendar () {
  return { type: CALENDAR_UNLOAD };
}