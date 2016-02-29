import { MESSAGE_LOAD, MESSAGE_LOAD_SUCCESS,
  MESSAGE_UNLOAD } from '../actions/actions';

const initialState = {
  changing: false,
  message: { files: [] }
};

const handlers = {

  [MESSAGE_LOAD]: (state, action) => ({
    changing: true
  }),

  [MESSAGE_LOAD_SUCCESS]: (state, action) => ({
    message: action.message,
    nextMessage: action.nextMessage,
    previousMessage: action.previousMessage,
    changing: false
  }),

  [MESSAGE_UNLOAD]: (state, action) => (initialState)

};

export default function messageReducer (state = initialState, action) {
  let handler = handlers[action.type];
  if (!handler) return state;
  return { ...state, ...handler(state, action) };
}
