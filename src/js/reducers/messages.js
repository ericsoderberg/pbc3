import { MESSAGES_LOAD, MESSAGES_LOAD_SUCCESS,
  MESSAGES_SEARCH, MESSAGES_SEARCH_SUCCESS,
  MESSAGES_MORE, MESSAGES_MORE_SUCCESS,
  MESSAGES_UNLOAD } from '../actions/actions';

const initialState = {
  changing: false,
  count: 0,
  filter: {},
  messages: []
};

const handlers = {

  [MESSAGES_LOAD]: (state, action) => ({
    filter: { search: action.search },
    changing: true
  }),

  [MESSAGES_LOAD_SUCCESS]: (state, action) => ({
    messages: action.messages,
    filter: action.filter,
    count: action.count,
    changing: false
  }),

  [MESSAGES_SEARCH]: (state, action) => ({
    filter: { search: action.search },
    changing: true
  }),

  [MESSAGES_SEARCH_SUCCESS]: (state, action) => ({
    messages: action.messages,
    filter: action.filter,
    count: action.count,
    changing: false
  }),

  [MESSAGES_MORE]: (state, action) => ({
    offset: action.offset
  }),

  [MESSAGES_MORE_SUCCESS]: (state, action) => ({
    messages: state.messages.concat(action.messages)
  }),

  [MESSAGES_UNLOAD]: (state, action) => (initialState)

};

export default function messagesReducer (state = initialState, action) {
  let handler = handlers[action.type];
  if (!handler) return state;
  return { ...state, ...handler(state, action) };
}
