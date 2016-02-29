import { PAGE_LOAD, PAGE_LOAD_SUCCESS,
  PAGE_EDIT_LOAD, PAGE_EDIT_LOAD_SUCCESS,
  PAGE_UNLOAD } from '../actions/actions';

const initialState = {
  pageElements: []
};

const handlers = {

  [PAGE_LOAD]: (state, action) => (initialState),

  [PAGE_LOAD_SUCCESS]: (state, action) => (action.page),

  [PAGE_EDIT_LOAD]: (state, action) => (initialState),

  [PAGE_EDIT_LOAD_SUCCESS]: (state, action) => (action.page),

  [PAGE_UNLOAD]: (state, action) => (initialState)

};

export default function pageReducer (state = initialState, action) {
  let handler = handlers[action.type];
  if (!handler) return state;
  return { ...state, ...handler(state, action) };
}
