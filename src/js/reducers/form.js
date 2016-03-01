import { FORM_LOAD, FORM_LOAD_SUCCESS,
  FORM_EDIT_LOAD, FORM_EDIT_LOAD_SUCCESS,
  FORM_FILL_EDIT_LOAD, FORM_FILL_EDIT_LOAD_SUCCESS,
  FORM_UNLOAD } from '../actions/actions';

const initialState = {
  formSections: []
};

const handlers = {

  [FORM_LOAD]: (state, action) => (initialState),

  [FORM_LOAD_SUCCESS]: (state, action) => (action.form),

  [FORM_EDIT_LOAD]: (state, action) => (initialState),

  [FORM_EDIT_LOAD_SUCCESS]: (state, action) => (action.form),

  [FORM_FILL_EDIT_LOAD]: (state, action) => (initialState),

  [FORM_FILL_EDIT_LOAD_SUCCESS]: (state, action) => (action.form),

  [FORM_UNLOAD]: (state, action) => (initialState)

};

export default function formReducer (state = initialState, action) {
  let handler = handlers[action.type];
  if (!handler) return state;
  return { ...state, ...handler(state, action) };
}
