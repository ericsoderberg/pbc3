import { SEARCH_QUERY, SEARCH_QUERY_SUCCESS,
  SEARCH_UNLOAD } from '../actions/actions';

const initialState = {};

const handlers = {

  [SEARCH_QUERY]: (state, action) => ({ query: action.query }),

  [SEARCH_QUERY_SUCCESS]: (state, action) => ({ results: action.results }),

  [SEARCH_UNLOAD]: (state, action) => (initialState)

};

export default function searchReducer (state = initialState, action) {
  let handler = handlers[action.type];
  if (!handler) return state;
  return { ...handler(state, action) };
}
