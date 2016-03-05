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
    REST.get(loc.pathname).end((err, res) => {
      if (!err && res.ok) {
        dispatch({
          type: MESSAGE_LOAD_SUCCESS,
          message: res.body.message,
          nextMessage: res.body.nextMessage,
          previousMessage: res.body.previousMessage
        });
      }
    });
  };
}

export function unloadMessage () {
  return { type: MESSAGE_UNLOAD };
}