import React from 'react';
import PageBuilder from './components/PageBuilder';

const Root = (props) => (
  <div>{props.children}</div>
);

export default { path: '/', component: Root,
  childRoutes: [
    { path: 'pages/:id/edit_contents', component: PageBuilder}
  ]
};
