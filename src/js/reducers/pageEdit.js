import { PAGE_EDIT_LOAD, PAGE_EDIT_LOAD_SUCCESS,
  PAGE_UNLOAD } from '../actions/actions';

const initialState = {};

const handlers = {

  [PAGE_EDIT_LOAD]: (state, action) => (initialState),

  [PAGE_EDIT_LOAD_SUCCESS]: (state, action) => (action.edit),

  [PAGE_UNLOAD]: (state, action) => (initialState)

};

export default function pageEditReducer (state = initialState, action) {
  let handler = handlers[action.type];
  if (!handler) return state;
  return { ...state, ...handler(state, action) };
}
