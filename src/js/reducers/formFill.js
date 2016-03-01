import { FORM_FILL_EDIT_LOAD, FORM_FILL_EDIT_LOAD_SUCCESS,
  FORM_FILL_UNLOAD } from '../actions/actions';

const initialState = {
  filledFields: []
};

const handlers = {

  [FORM_FILL_EDIT_LOAD]: (state, action) => (initialState),

  [FORM_FILL_EDIT_LOAD_SUCCESS]: (state, action) => (action.formFill),

  [FORM_FILL_UNLOAD]: (state, action) => (initialState)

};

export default function formFillReducer (state = initialState, action) {
  let handler = handlers[action.type];
  if (!handler) return state;
  return { ...state, ...handler(state, action) };
}
