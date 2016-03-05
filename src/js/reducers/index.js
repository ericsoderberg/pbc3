import { INDEX_LOAD, INDEX_LOAD_SUCCESS,
  INDEX_SEARCH, INDEX_SEARCH_SUCCESS,
  INDEX_MORE, INDEX_MORE_SUCCESS,
  INDEX_UNLOAD } from '../actions/actions';

const initialState = {
  category: undefined,
  changing: false,
  context: {},
  count: 0,
  editUrl: undefined,
  filter: {},
  items: [],
  newUrl: undefined
};

const handlers = {

  [INDEX_LOAD]: (state, action) => ({
    category: action.category,
    filter: { search: action.search },
    changing: true
  }),

  [INDEX_LOAD_SUCCESS]: (state, action) => ({
    changing: false,
    context: action.context,
    ...action.result
  }),

  [INDEX_SEARCH]: (state, action) => ({
    filter: { search: action.search },
    changing: true
  }),

  [INDEX_SEARCH_SUCCESS]: (state, action) => ({
    changing: false,
    ...action.result
  }),

  [INDEX_MORE]: (state, action) => ({
    offset: action.offset
  }),

  [INDEX_MORE_SUCCESS]: (state, action) => ({
    items: state.items.concat(action.result.items)
  }),

  [INDEX_UNLOAD]: (state, action) => (initialState)

};

export default function indexReducer (state = initialState, action) {
  let handler = handlers[action.type];
  if (!handler) return state;
  return { ...state, ...handler(state, action) };
}