import { PAGE_LOAD, PAGE_LOAD_SUCCESS } from '../actions/actions';

const initialState = {
  page: { pageElements: [] }
};

const handlers = {

  [PAGE_LOAD]: (state, action) => (initialState),

  [PAGE_LOAD_SUCCESS]: (state, action) => (action.page)

};

export default function pageReducer (state = initialState, action) {
  let handler = handlers[action.type];
  if (!handler) return state;
  return { ...state, ...handler(state, action) };
}
