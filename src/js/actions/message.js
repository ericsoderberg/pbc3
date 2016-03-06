import REST from '../utils/REST';
import history from '../routeHistory';

export const MESSAGE_LOAD = 'MESSAGE_LOAD';
export const MESSAGE_LOAD_SUCCESS = 'MESSAGE_LOAD_SUCCESS';
export const MESSAGE_UNLOAD = 'MESSAGE_UNLOAD';

export function loadMessage (id) {
  return function (dispatch) {
    const loc = history.createLocation(document.location.pathname +
      document.location.search);
    dispatch({ type: MESSAGE_LOAD, id: id });
    REST.get(loc.pathname).then(response => {
      dispatch({ type: MESSAGE_LOAD_SUCCESS, ...response.body });
    });
  };
}

export function unloadMessage () {
  return { type: MESSAGE_UNLOAD };
}
