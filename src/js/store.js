import { createStore, combineReducers, compose, applyMiddleware } from 'redux';
import thunk from 'redux-thunk';

// TODO: fix webpack loader to allow import * from './reducers'
import calendar from './reducers/calendar';
import form from './reducers/form';
import formEdit from './reducers/formEdit';
import formFill from './reducers/formFill';
import formFillEdit from './reducers/formFillEdit';
import index from './reducers/index';
import message from './reducers/message';
import messages from './reducers/messages';
import page from './reducers/page';
import pageEdit from './reducers/pageEdit';
import search from './reducers/search';
import site from './reducers/site';

export default compose(
  applyMiddleware(thunk)
)(createStore)(combineReducers({
  calendar,
  form,
  formEdit,
  formFill,
  formFillEdit,
  index,
  message,
  messages,
  page,
  pageEdit,
  search,
  site
}));
