import { FORM_FILL_EDIT_LOAD, FORM_FILL_EDIT_LOAD_SUCCESS,
  FORM_FILL_ADD_SUCCESS, FORM_FILL_ADD_FAILURE,
  FORM_FILL_UPDATE_SUCCESS, FORM_FILL_UPDATE_FAILURE,
  FORM_FILL_DELETE_SUCCESS,
  FORM_FILL_UNLOAD } from '../actions/actions';

const initialState = {
  done: false,
  errors: undefined
};

const handlers = {

  [FORM_FILL_EDIT_LOAD]: (state, action) => (initialState),

  [FORM_FILL_EDIT_LOAD_SUCCESS]: (state, action) => (action.edit),

  [FORM_FILL_ADD_SUCCESS]: (state, action) => ({ done: true }),

  [FORM_FILL_ADD_FAILURE]: (state, action) => ({ errors: action.errors }),

  [FORM_FILL_UPDATE_SUCCESS]: (state, action) => ({ done: true }),

  [FORM_FILL_UPDATE_FAILURE]: (state, action) => ({ errors: action.errors }),

  [FORM_FILL_DELETE_SUCCESS]: (state, action) => ({ done: true }),

  [FORM_FILL_UNLOAD]: (state, action) => (initialState)

};

export default function formFillEditReducer (state = initialState, action) {
  let handler = handlers[action.type];
  if (!handler) return state;
  return { ...state, ...handler(state, action) };
}
