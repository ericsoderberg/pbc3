import { SITE_LOAD, SITE_LOAD_SUCCESS } from '../actions/actions';

const initialState = {};

const handlers = {

  [SITE_LOAD]: (state, action) => (initialState),

  [SITE_LOAD_SUCCESS]: (state, action) => (action.site)

};

export default function siteReducer (state = initialState, action) {
  let handler = handlers[action.type];
  if (!handler) return state;
  return { ...handler(state, action) };
}
