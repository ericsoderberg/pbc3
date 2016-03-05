import { FORM_FILLS_LOAD_SUCCESS, FORM_FILLS_UNLOAD } from '../actions/actions';

const initialState = {};

const handlers = {

  [FORM_FILLS_LOAD_SUCCESS]: (state, action) => {
    let result = {};
    result[action.form.id] = action.formFills;
    return result;
  },

  [FORM_FILLS_UNLOAD]: (state, action) => {
    let result = {};
    result[action.formId] = undefined;
    return result;
  }

};

export default function formFillsReducer (state = initialState, action) {
  let handler = handlers[action.type];
  if (!handler) return state;
  return { ...state, ...handler(state, action) };
}
