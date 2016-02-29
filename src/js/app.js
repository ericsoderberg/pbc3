
import 'scss/index.scss';

import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import { Router } from 'react-router';
import history from './routeHistory';
import routes from './appRoutes';
import store from './store';

let element = document.getElementById('content');

ReactDOM.render((
  <Provider store={store}>
    <Router routes={routes} history={history} />
  </Provider>
), element);
