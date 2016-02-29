import { CALENDAR_LOAD, CALENDAR_LOAD_SUCCESS,
  CALENDAR_SEARCH, CALENDAR_SEARCH_SUCCESS,
  CALENDAR_UNLOAD } from '../actions/actions';

const initialState = {
  changing: false,
  daysOfWeek: [],
  filter: {},
  next: undefined,
  previous: undefined,
  weeks: []
};

const handlers = {

  [CALENDAR_LOAD]: (state, action) => ({
    filter: { search: action.search },
    changing: true
  }),

  [CALENDAR_LOAD_SUCCESS]: (state, action) => ({
    weeks: action.weeks,
    filter: action.filter,
    next: action.next,
    previous: action.previous,
    changing: false
  }),

  [CALENDAR_SEARCH]: (state, action) => ({
    filter: { search: action.search },
    changing: true
  }),

  [CALENDAR_SEARCH_SUCCESS]: (state, action) => ({
    weeks: action.weeks,
    filter: action.filter,
    changing: false
  }),

  [CALENDAR_UNLOAD]: (state, action) => (initialState)

};

export default function calendarReducer (state = initialState, action) {
  let handler = handlers[action.type];
  if (!handler) return state;
  return { ...state, ...handler(state, action) };
}
