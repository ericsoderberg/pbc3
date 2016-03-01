import { FORM_EDIT_LOAD, FORM_EDIT_LOAD_SUCCESS,
  FORM_UNLOAD } from '../actions/actions';

const initialState = {};

const handlers = {

  [FORM_EDIT_LOAD]: (state, action) => (initialState),

  [FORM_EDIT_LOAD_SUCCESS]: (state, action) => (action.edit),

  [FORM_UNLOAD]: (state, action) => (initialState)

};

export default function formEditReducer (state = initialState, action) {
  let handler = handlers[action.type];
  if (!handler) return state;
  return { ...state, ...handler(state, action) };
}
